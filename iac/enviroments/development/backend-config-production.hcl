bucket         = "state-tf-orbidi"
key            = "production/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock-prod"
encrypt        = true
