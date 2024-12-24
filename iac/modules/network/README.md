# Módulo: Networking

Este módulo configura la infraestructura de red en AWS utilizando Terraform. Proporciona los componentes esenciales para una red segura y escalable, como VPCs, subredes públicas y privadas, tablas de ruteo y grupos de seguridad.

## Funcionalidades

### 1. **VPC**
- Crea una Virtual Private Cloud (VPC) con soporte para DNS interno y nombres de host.
- Define un bloque CIDR configurado por el usuario.

### 2. **Subredes Públicas y Privadas**
- Genera subredes públicas y privadas distribuidas en múltiples zonas de disponibilidad.
- Las subredes públicas permiten asignar direcciones IP públicas a instancias al iniciarlas.

### 3. **Internet Gateway**
- Proporciona acceso a Internet para las subredes públicas mediante un Internet Gateway (IGW).
- Configura rutas a Internet en las tablas de ruteo asociadas a las subredes públicas.

### 4. **Tablas de Ruteo**
- Crea una tabla de ruteo pública con una ruta predeterminada hacia el IGW.
- Asocia las subredes públicas a esta tabla de ruteo.

### 5. **Grupos de Seguridad**
- Implementa grupos de seguridad para controlar el tráfico:
  - **Grupo Público**: Permite tráfico HTTP (puerto 80) y HTTPS (puerto 443) desde cualquier origen.
  - **Grupo Privado**: Permite tráfico solo desde el grupo de seguridad público.
- Configura reglas de salida para permitir todo el tráfico saliente.

## Recursos Creados

- **VPC**: Red privada virtual para alojar recursos.
- **Subredes**: Subredes públicas y privadas distribuidas en zonas de disponibilidad.
- **Internet Gateway**: Proporciona acceso a Internet para subredes públicas.
- **Tablas de Ruteo**: Maneja el ruteo interno y externo de la VPC.
- **Grupos de Seguridad**: Protege los recursos dentro de las subredes.

## Uso

### Entradas
El módulo requiere las siguientes variables:
- `environment`: Identificador del entorno (e.g., `dev`, `prod`).
- `vpc_cidr`: Bloque CIDR para la VPC.
- `availability_zones`: Lista de zonas de disponibilidad para distribuir las subredes.
- `public_subnets`: Lista de bloques CIDR para subredes públicas.
- `private_subnets`: Lista de bloques CIDR para subredes privadas.

### Salidas
- ID de la VPC
- IDs de las subredes públicas
- IDs de las subredes privadas
- ID del Internet Gateway
- IDs de los grupos de seguridad

## Seguridad
- **Aislamiento de Red**: Las subredes privadas no tienen acceso directo a Internet.
- **Restricción de Tráfico**: Los grupos de seguridad permiten tráfico solo desde fuentes específicas.
- **Control de Salida**: Se permite todo el tráfico saliente para garantizar conectividad.

## Ejemplo

```hcl
module "networking" {
  source              = "./modules/networking"
  environment         = "prod"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]
}
```


