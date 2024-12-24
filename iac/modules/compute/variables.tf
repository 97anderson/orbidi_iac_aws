# Variable file used in the compute deployment environment

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "alb_subnets" {
  description = "List of public subnets for ALB"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., production, dev)"
}

variable "instance_type" {
  description = "Instance type for ECS instances"
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired capacity for ASG"
  default     = 2
}

variable "min_size" {
  description = "Minimum size for ASG"
  default     = 2
}

variable "max_size" {
  description = "Maximum size for ASG"
  default     = 5
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
}

variable "aws_region" {
  description = "La región de AWS para el entorno"
  type        = string
  default     = "us-east-1"
}

variable "ssh_key_path" {
  description = "Clave para conexion a instancia ECS"
  type        = string
}

variable "image_id" {
  description = "AMI para despliegue de ECS"
  type        = string
}

variable "ecr_image_url" {
  description = "url de imagen de ECR para despliegue de contenedores"
  type        = string
}