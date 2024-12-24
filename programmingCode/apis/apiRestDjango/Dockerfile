# Etapa de compilación
FROM python:3.11-slim as builder

# Variables de entorno para la robustez y seguridad
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instalación de dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev

# Crear directorio de la aplicación
WORKDIR /app

# Copiar los archivos del proyecto
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código fuente
COPY . .

# Imagen de producción
FROM python:3.11-slim

WORKDIR /app

# Copiar dependencias desde la etapa anterior
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /app /app

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

