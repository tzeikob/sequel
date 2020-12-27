# Pull the base image
FROM mysql:5.7

# Install various third-party dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    wget \
    tree \
    unzip \
    htop \
  && rm -rf /var/lib/apt/lists/*