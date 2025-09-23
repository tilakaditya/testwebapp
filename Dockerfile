# Dockerfile (multi-stage, Python 3.11)
FROM python:3.11-slim AS builder

WORKDIR /app
# Install build deps if needed (uncomment if you need gcc, libpq-dev, etc)
# RUN apt-get update && apt-get install -y build-essential --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

# Copy app source
COPY . /app

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app /app

ENV PYTHONUNBUFFERED=1

EXPOSE 8000
# Replace the command below to match your app entry (Flask: app:app, FastAPI: main:app)
CMD ["python", "app.py"]
