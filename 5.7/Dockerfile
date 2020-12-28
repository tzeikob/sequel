# Pull the base image
FROM ubuntu:18.04

# Create user and user group for mysql
RUN groupadd -r mysql && useradd -r -g mysql mysql

# Install various dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano \
    gnupg \
    openssl \
    perl \
    pwgen \
    xz-utils \
    gosu \
  && rm -rf /var/lib/apt/lists/*

# Trust mysql public repository
RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
  key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
  export GNUPGHOME="$(mktemp -d)"; \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME"; \
  apt-key list > /dev/null

# Install MySQL Server
ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.32-1ubuntu18.04

RUN echo 'deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-5.7' > /etc/apt/sources.list.d/mysql.list

RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select true; \
  } | debconf-set-selections \
  && apt-get update \
  && apt-get install -y mysql-server="${MYSQL_VERSION}" \
  && find /etc/mysql/ -name '*.cnf' -print0 \
    | xargs -0 grep -lZE '^(bind-address|log)' \
    | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
  && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
  && chmod 1777 /var/run/mysqld /var/lib/mysql

# Set an exposed volume for SQL script files
RUN mkdir -p /home/scripts

VOLUME [ "/var/lib/mysql", "/home/scripts" ]

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]