aws_region    = "us-west-2"
ami_id        = "ami-04067ca5b3061f2ba"
instance_type = "t3.medium"
key_name      = "cs312-key"
admin_cidr    = "50.43.50.192/32"

ecr_repo_name = "cs312-ops2-minecraft"
image_tag     = "ops3-v2"

backup_bucket        = "cs312-ops2-minecraft-backups-zane"
minecraft_motd       = "Zane Garvey CS312 Ops3 Minecraft Server"