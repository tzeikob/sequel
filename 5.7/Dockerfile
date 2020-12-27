# Pull the base image
FROM mysql:5.7

# Install various third-party dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    wget \
    tree \
    unzip \
    htop \
    locales \
  && rm -rf /var/lib/apt/lists/*

# Set the locale to UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set an exposed volume for SQL script files
RUN mkdir -p /home/scripts

VOLUME [ "/home/scripts" ]