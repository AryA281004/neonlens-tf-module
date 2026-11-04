output "instance_id" {
  description = "MongoDB EC2 instance ID."
  value       = aws_instance.mongodb.id
}

output "private_ip" {
  description = "Private IP address of the MongoDB EC2 instance."
  value       = aws_instance.mongodb.private_ip
}

output "private_dns" {
  description = "Private DNS name of the MongoDB EC2 instance."
  value       = aws_instance.mongodb.private_dns
}

output "availability_zone" {
  description = "Availability zone hosting the MongoDB instance and data volume."
  value       = aws_instance.mongodb.availability_zone
}

output "security_group_id" {
  description = "MongoDB security group ID."
  value       = aws_security_group.mongodb.id
}

output "data_volume_id" {
  description = "MongoDB encrypted EBS data volume ID."
  value       = aws_ebs_volume.mongodb.id
}

output "data_volume_size" {
  description = "MongoDB data volume size in GiB."
  value       = aws_ebs_volume.mongodb.size
}

output "secret_arn" {
  description = "Secrets Manager ARN containing MongoDB credentials."
  value       = aws_secretsmanager_secret.mongodb.arn
}

output "connection_uri" {
  description = "MongoDB connection URI for the application."
  value       = "mongodb://neonlenspictures_db_user:aryandudhat281004@${aws_instance.mongodb.private_ip}:27017/${var.database_name}?authSource=${var.database_name}"
  sensitive   = true
}