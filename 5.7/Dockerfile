# MySQL Server 5.7

# Pull the base image
FROM debian:buster-slim

# Add our user and group first
RUN groupadd -r mysql && useradd -r -g mysql mysql

# Install thrid-party dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
  && rm -rf /var/lib/apt/lists/*
