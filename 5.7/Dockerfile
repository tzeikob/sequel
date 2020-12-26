# MySQL Server 5.7

# Pull the base image
FROM debian:buster-slim

# Add our user and group first
RUN groupadd -r mysql && useradd -r -g mysql mysql

# Install thrid-party dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    pwgen \
    openssl \
    perl \
  && rm -rf /var/lib/apt/lists/*

# Set the MySQL version
ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.32-1debian10

# Add the MySQL repository to the sources
RUN echo 'deb http://repo.mysql.com/apt/debian/ buster mysql-5.7' > /etc/apt/sources.list.d/mysql.list
