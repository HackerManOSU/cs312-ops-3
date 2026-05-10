aws_region     = "us-east-1"
ami_id         = "ami-05cf1e9f73fbad2e2"
instance_type  = "t3.micro"
key_name       = "cs312-key-new"
admin_cidr     = "50.43.50.192/32"

ecr_repo_name  = "cs312-ops2-minecraft"
image_tag      = "ops3-v1"

backup_bucket_region    = us-west-2
backup_bucket  = cs312-ops2-minecraft-backups-zane
minecraft_motd = "Zane Garvey CS312 Ops3 Minecraft Server"