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

# Install more locales
RUN apt-get update \
  && apt-get install -y locales \
  && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Add MySQL public repository
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
RUN set -ex; \
  key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
  export GNUPGHOME="$(mktemp -d)"; \
  ( \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" \
    || gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" \
    || gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" \
    || gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" \
  ); \
  gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME"; \
  apt-key list > /dev/null

ENV MYSQL_MAJOR=8.0
ENV MYSQL_VERSION=8.0.22-1ubuntu18.04

RUN echo 'deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-'$MYSQL_MAJOR > /etc/apt/sources.list.d/mysql.list

# Install MySQL Server
RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
  } | debconf-set-selections \
  && apt-get update \
  && apt-get install -y \
    mysql-community-client="${MYSQL_VERSION}" \
    mysql-community-server-core="${MYSQL_VERSION}" \
  && rm -rf /var/lib/apt/lists/* \
  # Clean up and initialize the data folder
  && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
  && chmod 1777 /var/run/mysqld /var/lib/mysql

VOLUME /var/lib/mysql

# Copy default configuration files
COPY config/ /etc/mysql/

# Set the container's entry point
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x usr/local/bin/docker-entrypoint.sh \
  && ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]