# Módulo: Compute

Este módulo proporciona una configuración integral para desplegar y gestionar recursos de cómputo en AWS utilizando Terraform. Está diseñado para manejar la creación de clústeres ECS, balanceo de carga de aplicaciones, autoescalado y configuración de seguridad.

## Funcionalidades

### 1. **Application Load Balancer (ALB)**
- Crea un Application Load Balancer para enrutar el tráfico a los servicios ECS.
- Soporta listeners HTTP y HTTPS con grupos objetivo configurables.
- Configurado con grupos de seguridad para restringir el acceso a los puertos necesarios (80 y 443).

### 2. **Clúster ECS**
- Provisiona un clúster ECS con instancias EC2 utilizando un proveedor de capacidad.
- Incluye definiciones de tareas y servicios ECS para cargas de trabajo en contenedores.
- Soporta integración con Amazon ECR para almacenamiento y recuperación de imágenes de contenedores.

### 3. **Autoescalado**
- Configura un Auto Scaling Group (ASG) para gestionar el ciclo de vida de las instancias EC2 en el clúster.
- Habilita escalado dinámico basado en la utilización de CPU y memoria mediante alarmas de CloudWatch.
  - **Escalado hacia arriba** cuando la utilización de CPU supera el 75%.
  - **Escalado hacia abajo** cuando la utilización de CPU cae por debajo del 25%.
- El escalado administrado dentro del proveedor de capacidad ECS asegura una asignación óptima de recursos.

### 4. **Seguridad**
- Implementa grupos de seguridad para ALB e instancias ECS para controlar el tráfico entrante y saliente.
  - El grupo de seguridad del ALB permite acceso HTTP/HTTPS desde internet.
  - El grupo de seguridad de ECS restringe el acceso solo para permitir comunicación desde el ALB.
- Se definen roles y políticas IAM para las tareas y servicios ECS para garantizar acceso seguro a los recursos necesarios de AWS.

## Recursos Creados

- **Load Balancer**: AWS ALB con listeners y grupos objetivo.
- **Clúster ECS**: Configurado para el tipo de lanzamiento EC2.
- **Definiciones de Tareas**: Especifica los contenedores y los recursos requeridos.
- **Servicios ECS**: Gestiona el despliegue de contenedores e integra con el balanceador de carga.
- **Auto Scaling Group**: Ajusta automáticamente el número de instancias EC2.
- **Roles y Políticas IAM**: Proporciona acceso seguro para tareas, servicios y autoescalado.
- **Grupos de Seguridad**: Protege el ALB y las instancias ECS.

## Uso

### Entradas
El módulo requiere las siguientes variables:
- `environment`: Un identificador único para el entorno (por ejemplo, `dev`, `prod`).
- `alb_subnets`: Subnets para el Application Load Balancer.
- `vpc_id`: ID de la VPC donde se desplegarán los recursos.
- `private_subnets`: Subnets para el Auto Scaling Group.
- `instance_type`: Tipo de instancia EC2 para el Auto Scaling Group.
- `image_id`: ID de la AMI para las instancias EC2.
- `desired_capacity`, `min_size`, `max_size`: Parámetros para el Auto Scaling Group.
- `ecr_image_url`: URL de la imagen del contenedor en Amazon ECR.
- `ssh_key_path`: Ruta a la clave pública SSH para acceder a las instancias EC2.
- `ssl_certificate_arn` (opcional): ARN del certificado SSL para HTTPS.

### Salidas
- ID del Clúster ECS
- Nombre DNS del Load Balancer
- Nombre del Auto Scaling Group

## Autoescalado Explicado
- **Escalado Dinámico**: Ajusta el número de instancias EC2 según la demanda de la aplicación.
  - Utiliza alarmas de CloudWatch para los umbrales de utilización de CPU y memoria.
  - Garantiza alta disponibilidad y eficiencia de costos al escalar recursos hacia arriba o hacia abajo según sea necesario.

## Consideraciones de Seguridad
- **Acceso de Mínimos Privilegios**: Los roles y políticas IAM otorgan solo los permisos necesarios a las tareas y servicios ECS.
- **Restricción de Tráfico**: Los grupos de seguridad están configurados para permitir tráfico solo desde las fuentes necesarias.
- **Aislamiento de Red**: Los recursos se despliegan en subnets privadas para limitar la exposición a internet.

## Ejemplo

```hcl
module "compute" {
  source           = "./modules/compute"
  environment      = "prod"
  alb_subnets      = ["subnet-abc123", "subnet-def456"]
  vpc_id           = "vpc-xyz789"
  private_subnets  = ["subnet-ghi012", "subnet-jkl345"]
  instance_type    = "t3.medium"
  image_id         = "ami-0abcdef1234567890"
  desired_capacity = 2
  min_size         = 1
  max_size         = 5
  ecr_image_url    = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
  ssh_key_path     = "~/.ssh/id_rsa.pub"
  ssl_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcdefg-1234-5678-abcd-1234567890ab"
}
```


