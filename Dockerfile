FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY feature-repo/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy feature repository
COPY feature-repo/ feature-repo/

# Copy infrastructure configurations
COPY infrastructure/ infrastructure/

# Set environment variables
ENV FEAST_FEATURE_STORE_CONFIG_PATH=/app/feature-repo/feature_store.yaml

# Expose ports for gRPC and HTTP
EXPOSE 6566 8080

# Start Feast server
CMD ["feast", "serve", "-h", "0.0.0.0"] 