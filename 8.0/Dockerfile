# Pull the base image
FROM ubuntu:18.04

# Create user and user group for mysql
RUN groupadd -r mysql && useradd -r -g mysql mysql

# Install various third-party dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano \
    gnupg \
    openssl \
    gosu \
    perl \
  && rm -rf /var/lib/apt/lists/*

# Set the container's entry point
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x usr/local/bin/docker-entrypoint.sh \
  && ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]