# Quick reference
 * Maintained by: [Iakovos Papadopoulos](https://github.com/tzeikob/sequel)
 * Based on: [Official Docker Team MySQL Server image](https://hub.docker.com/_/mysql)
 * Where to get help: [Docker Community Forums](https://forums.docker.com/)

# Supported tags and respective `Dockerfile` links
 * [5.7.32, 5.7, 5](https://github.com/tzeikob/sequel/blob/xxx/5.7/Dockerfile)

# How to use this image

## Start an image instance

Starting a instance is simple:

```
mkdir -p any-name
cd any-name

docker run -d --name any-name \
  -e MYSQL_ROOT_PASSWORD=secret-pass \
  -p 3306:3306 \
  -v $(pwd)/data:/var/lib/mysql:rw \
  -v $(pwd)/scripts:/home/scripts/:rw \
  tzeikob/sequel:tag
```

where `any-name` is the name you want to assign to the container, `secret-pass` is the secret password to be set for the root MySQL user and tag is the tag specifying the version of the MySQL server.

## Access container shell

The docker exec command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your mysql container:

```
docker exec -it any-name bash
```

## View container's log file

The log is available through Docker's container log, you can tail of the file by using the `follow` flag

```
docker logs -f -n all any-name
```