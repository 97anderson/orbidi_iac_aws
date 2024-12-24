# variables.tf

# Variables para la región de AWS
variable "aws_region" {
  description = "La región de AWS para el entorno"
  type        = string
  default     = "us-east-1"
}

# Declaración de la variable para especificar el entorno
variable "environment" {
  description = "El entorno a desplegar (production o development)"
  type        = string
}

# Tabla para cada ambiente 
variable "dynamodb_table" {
  description = "Tabla DynamoDB para bloqueo de estado remoto"
  type        = string
}

# Variables de Networking
variable "vpc_cidr" {
  description = "CIDR para la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de CIDRs para subredes públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDRs para subredes privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
}

# Variables de Compute
variable "desired_capacity" {
  description = "Capacidad deseada para ECS"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Tamaño mínimo del Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Tamaño máximo del Auto Scaling Group"
  type        = number
  default     = 5
}

variable "ssl_certificate_arn" {
  description = "ARN del certificado SSL"
  type        = string
}

variable "instance_type" {
  description = "Instance type for ECS instances"
  default     = "t3.micro" 
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