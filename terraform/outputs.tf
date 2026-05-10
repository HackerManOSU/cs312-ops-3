output "minecraft_public_ip" {
  description = "Public IP of the Minecraft server."
  value       = aws_instance.minecraft.public_ip
}

output "minecraft_endpoint" {
  description = "Minecraft connection endpoint."
  value       = "${aws_instance.minecraft.public_ip}:25565"
}

output "ecr_repo_uri" {
  description = "ECR repository URI."
  value       = data.aws_ecr_repository.minecraft.repository_url
}