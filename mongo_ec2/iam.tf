resource "aws_iam_role" "mongodb" {
  name = local.resource_names.iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = local.resource_names.iam_role
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.mongodb.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "mongodb_secret" {
  name = local.resource_names.iam_policy
  role = aws_iam_role.mongodb.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "ReadMongoDBCredentials"
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = var.secret_arn
    }]
  })
}

resource "aws_iam_instance_profile" "mongodb" {
  name = local.resource_names.instance_profile
  role = aws_iam_role.mongodb.name

  tags = local.common_tags
}