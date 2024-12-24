# Modulo de red
module "network" {
  source = "./modules/network"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  aws_region         = var.aws_region
}


## Módulo de Compute (ECS)
module "compute" {
  source = "./modules/compute"

  environment          = var.environment
  vpc_id               = module.network.vpc_id
  private_subnets      = module.network.private_subnets
  alb_subnets          = module.network.public_subnets
  instance_type        = var.instance_type
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  ssl_certificate_arn  = var.ssl_certificate_arn
  ssh_key_path         = var.ssh_key_path
  image_id             = var.image_id
  ecr_image_url        = var.ecr_image_url
}