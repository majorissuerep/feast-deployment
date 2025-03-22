FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Copy feature repository
COPY feature-repo/ .
RUN pip install --no-cache-dir -r requirements.txt

# Copy infrastructure configurations
COPY infrastructure/ infrastructure/

# Set environment variables
ENV FEAST_FEATURE_STORE_CONFIG_PATH=/app/feature_store.yaml

# Expose ports for gRPC and HTTP
EXPOSE 6566 8080

# Start Feast server
CMD ["feast", "serve", "--host", "0.0.0.0", "--port", "8080", "--grpc-port", "6566"] 