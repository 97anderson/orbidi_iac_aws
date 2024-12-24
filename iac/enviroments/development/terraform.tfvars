# variables a utilizar para ambiente de desarrollo

environment         = "develoment"
aws_region          = "us-east-1"
dynamodb_table      = "terraform-lock-prod"

# Networking
vpc_cidr            = "11.0.0.0/24"
public_subnets      = ["11.0.0.0/28", "11.0.0.16/28"]
private_subnets     = ["11.0.0.32/28", "11.0.0.48/28"]
availability_zones  = ["us-east-1a", "us-east-1b"]

# ECS
instance_type       = "t2.micro"
desired_capacity    = 2
min_size            = 2
max_size            = 5
ssl_certificate_arn = "arn:aws:acm:region:account:certificate/xxxxxxx"
ssh_key_path        = "/root/.ssh/id_rsa.pub"
image_id            = "ami-0e2c8caa4b6378d8c"
ecr_image_url       = "490004639204.dkr.ecr.us-east-1.amazonaws.com/orbidi/fastapi:latest"

