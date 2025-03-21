FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Feast and dependencies
COPY feature_repo/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy feature repository
COPY feature_repo/ /app/feature_repo/

# Default environment variables
ENV FEAST_FEATURE_STORE_CONFIG_PATH=/app/feature_repo/feature_store.yaml
ENV FEAST_USAGE=False
ENV PROMETHEUS_MULTIPROC_DIR=/tmp

# Create directory for Prometheus metrics
RUN mkdir -p /tmp && chmod 777 /tmp

# Expose Feast Server ports
EXPOSE 6566 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:8080/healthz || exit 1

# Start Feast server
CMD ["feast", "serve", "-h", "0.0.0.0", "--no-access-log"] 