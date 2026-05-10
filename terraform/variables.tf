variable "aws_region" {
  description = "AWS region for the Minecraft infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH."
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed to SSH into the server."
  type        = string
}

variable "ecr_repo_name" {
  description = "Existing ECR repo containing the Minecraft image."
  type        = string
}

variable "image_tag" {
  description = "Pinned Minecraft image tag to deploy."
  type        = string
}

variable "backup_bucket" {
  description = "Existing S3 bucket used for Minecraft world backups."
  type        = string
}

variable "minecraft_motd" {
  description = "Minecraft server MOTD. Must include name or student ID."
  type        = string
}