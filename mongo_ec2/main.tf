data "aws_region" "current" {}

data "aws_subnet" "mongodb" {
  id = var.private_subnet_id
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Existing credentials are managed outside Terraform in Secrets Manager.

resource "aws_ebs_volume" "mongodb" {
  availability_zone = data.aws_subnet.mongodb.availability_zone
  size              = var.database_volume_size
  type              = "gp3"
  encrypted         = true

  tags = merge(local.common_tags, {
    Name = local.resource_names.mongodb_volume
  })
}

resource "aws_instance" "mongodb" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.mongodb.id]
  iam_instance_profile        = aws_iam_instance_profile.mongodb.name
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    aws_region     = data.aws_region.current.region
    secret_arn     = var.secret_arn
    database_name  = var.database_name
    data_volume_id = aws_ebs_volume.mongodb.id
    environment    = var.environment
  })

  user_data_replace_on_change = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring = true

  tags = merge(local.common_tags, {
    Name = local.resource_names.mongodb_instance
  })

  depends_on = [
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy.mongodb_secret
  ]

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_volume_attachment" "mongodb" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.mongodb.id
  instance_id = aws_instance.mongodb.id

  stop_instance_before_detaching = true
}