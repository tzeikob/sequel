# MySQL Server 5.6

# Pull the mysql:5.6 image
FROM mysql:5.6

ENV MY_ENV_VAR 666

LABEL maintainer="iakopap@gmail.com"

# Install various dependencies
RUN apt-get update && apt-get install -y wget