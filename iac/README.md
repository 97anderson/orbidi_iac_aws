# Proyecto de Infraestructura como Código (IaC) en Terraform

Este proyecto define una infraestructura completa en AWS utilizando **Terraform**. Está diseñado para ser modular, reutilizable y escalable, proporcionando recursos de red y cómputo que pueden implementarse en múltiples entornos.

## Estructura del Proyecto

```plaintext
├── backend.tf                      # Configuración remota de estado de Terraform
├── enviroments                     # Variables y configuraciones por entorno
│   ├── development
│   │   ├── backend-config-production.hcl
│   │   └── terraform.tfvars        # Variables específicas del entorno de desarrollo
│   └── production
│       ├── backend-config-production.hcl
│       └── terraform.tfvars        # Variables específicas del entorno de producción
├── main.tf                         # Archivo principal que une todos los módulos
├── modules                         # Módulos reutilizables
│   ├── compute                     # Módulo para recursos de cómputo (ECS, Auto Scaling, etc.)
│   │   ├── README.md               # Documentación del módulo compute
│   │   ├── main.tf                 # Definición de recursos para cómputo
│   │   ├── outputs.tf              # Salidas del módulo compute
│   │   └── variables.tf            # Variables del módulo compute
│   └── network                     # Módulo para infraestructura de red (VPC, subredes, etc.)
│       ├── README.md               # Documentación del módulo network
│       ├── main.tf                 # Definición de recursos para red
│       ├── outputs.tf              # Salidas del módulo network
│       └── variables.tf            # Variables del módulo network
└── variables.tf                    # Variables globales del proyecto
```

## Módulos

### Módulo de Networking
Proporciona la infraestructura de red necesaria para soportar la aplicación:
- **VPC**: Configuración de una Virtual Private Cloud.
- **Subredes Públicas y Privadas**: Distribución en múltiples zonas de disponibilidad.
- **Internet Gateway y Rutas**: Para acceso a Internet desde subredes públicas.
- **Grupos de Seguridad**: Control de tráfico entrante y saliente.

Más detalles en [modules/network/README.md](modules/network/README.md).

### Módulo de Compute
Gestiona los recursos de cómputo necesarios para desplegar aplicaciones en contenedores:
- **ECS Cluster**: Configuración de un clúster ECS utilizando instancias EC2.
- **Auto Scaling Group**: Escalado automático de instancias EC2 basado en métricas de uso.
- **Application Load Balancer**: Balanceo de carga para enrutar el tráfico a los servicios ECS.
- **Definiciones de Tareas y Servicios ECS**: Gestión de contenedores en Amazon ECS.

Más detalles en [modules/compute/README.md](modules/compute/README.md).

## Entornos

El proyecto soporta múltiples entornos:
- **development**: Configuración para desarrollo.
- **production**: Configuración para producción.

Cada entorno tiene su propio conjunto de variables (`terraform.tfvars`) y configuración de backend para almacenar el estado de Terraform de forma remota.

## Uso

### Requisitos
- Terraform v1.5.0 o superior.
- Credenciales de AWS configuradas en el sistema.

### Inicialización del Proyecto
1. Clona el repositorio:
   ```bash
   git clone https://github.com/97anderson/orbidi_iac_aws.git
   cd iac_Orbidi/ 
   ```
2. Inicializa Terraform:
   ```bash
   terraform init -backend-config=enviroments/<entorno>/backend-config-production.hcl
   ```

### Despliegue
1. Previsualiza los cambios:
   ```bash
   terraform plan -var-file=enviroments/<entorno>/terraform.tfvars
   ```
2. Aplica los cambios:
   ```bash
   terraform apply -var-file=enviroments/<entorno>/terraform.tfvars
   ```

### Destrucción
Para destruir la infraestructura:
```bash
terraform destroy -var-file=enviroments/<entorno>/terraform.tfvars
```

