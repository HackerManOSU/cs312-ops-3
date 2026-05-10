terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "minecraft" {
  name = var.ecr_repo_name
}

resource "aws_security_group" "minecraft" {
  name        = "cs312-ops3-minecraft-sg"
  description = "Allow SSH and Minecraft traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH admin access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "Minecraft clients"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cs312-ops3-minecraft-sg"
  }
}

resource "aws_instance" "minecraft" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.minecraft.id]

  iam_instance_profile = "LabInstanceProfile"

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
  }

  tags = {
    Name = "cs312-ops3-minecraft"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<EOF
[minecraft]
${aws_instance.minecraft.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem

[minecraft:vars]
aws_region=${var.aws_region}
ecr_repo_uri=${data.aws_ecr_repository.minecraft.repository_url}
image_tag=${var.image_tag}
backup_bucket=${var.backup_bucket}
minecraft_motd="${var.minecraft_motd}"
EOF
}

resource "null_resource" "ansible_config" {
  depends_on = [
    aws_instance.minecraft,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = <<EOT
sleep 45
cd ../ansible
ansible-galaxy collection install -r requirements.yml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml
EOT
  }

  triggers = {
    instance_id = aws_instance.minecraft.id
    image_tag   = var.image_tag
    motd        = var.minecraft_motd
  }
}