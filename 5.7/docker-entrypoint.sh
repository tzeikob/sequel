#!/bin/bash
set -eo pipefail
shopt -s nullglob

# Skip if we aren't running mysqld
if [ "$1" = 'mysqld' ]; then
  echo "Entrypoint script for MySQL Server ${MYSQL_VERSION} started"

  # Declare the password of the root user
  declare -g MYSQL_ROOT_PASSWORD
  MYSQL_ROOT_PASSWORD="root"

  # Declare data directory path and socket
  declare -g DATADIR SOCKET
  DATADIR="/var/lib/mysql"
  SOCKET="/var/run/mysqld/mysqld.sock"

  # Decalre a variable indicating the existence of the mysql database
  declare -g DATABASE_ALREADY_EXISTS
  if [ -d "$DATADIR/mysql" ]; then
    DATABASE_ALREADY_EXISTS="true"
  fi

  # Create data directories with permissions for mysql user on running as root
  mkdir -p "$DATADIR"
  if [ "$(id -u)" = "0" ]; then
    find "$DATADIR" \! -user mysql -exec chown mysql '{}' +
  fi

  # If you are root restart as mysql user
  if [ "$(id -u)" = "0" ]; then
    echo "Switching to dedicated user mysql"
    exec gosu mysql "$BASH_SOURCE" "$@"
  fi

  # Initialize database if there's no mysql database
  if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
    # Initialize database directories
    echo "Initializing database files"
    "$@" --initialize-insecure
    echo "Database files initialized"
    
    # Initializing certificates
    if command -v mysql_ssl_rsa_setup > /dev/null && [ ! -e "$DATADIR/server-key.pem" ]; then
      echo "Initializing certificates"
      mysql_ssl_rsa_setup --datadir="$DATADIR"
      echo "Certificates initialized"
    fi

    # Start temporary server to setup the root user
    echo "Starting temporary server"
    "$@" --skip-networking --socket="${SOCKET}" &
    echo "Waiting for server startup..."
    sleep 15
    echo "Temporary server started"

    # Setting up the root users
    echo "Setting up the root users"
    mysql --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" --comments --database=mysql <<-EOSQL
      SET @@SESSION.SQL_LOG_BIN=0;
      ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
      GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

      CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
      GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;

      FLUSH PRIVILEGES;
      DROP DATABASE IF EXISTS test;
		EOSQL
    echo "Root users have been set"

    echo "Shutting down temporary server"
    if ! mysqladmin shutdown -p"${MYSQL_ROOT_PASSWORD}" -uroot --socket="${SOCKET}"; then
      echo "Unable to shut down server"
      exit 1
    fi

    echo "CAUTION: This container is for DEVELOPMENT purposes only!"
    echo "MySQL init process done, ready for start up!"
    echo
  fi
fi

exec "$@"