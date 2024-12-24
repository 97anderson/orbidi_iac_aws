# Imagen base s
FROM python:3.9-slim-bullseye

# Variables de entorno y seguridad
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/code/.venv/bin:$PATH"

# directorio de trabajo
WORKDIR /code

# Crear y usario orbidi
RUN useradd -m orbidi && \
    mkdir -p /code && \
    chown -R orbidi:orbidi /code

USER orbidi

# Copiar e instalar las dependencias en un entorno virtual aislado
COPY --chown=appuser:appuser ./requirements.txt /code/requirements.txt
RUN python -m venv .venv && \
    .venv/bin/pip install --no-cache-dir --upgrade pip && \
    .venv/bin/pip install --no-cache-dir -r /code/requirements.txt

# Copiar la aplicación al directorio de trabajo
COPY --chown=orbidi:orbidi ./app /code/app

# Exponer el puerto de la aplicación
EXPOSE 80

# Comando de inicio
CMD ["fastapi", "run", "/code/app/main.py", "--port", "80"]

