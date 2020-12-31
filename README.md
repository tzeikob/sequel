## Quick reference
 * Maintained by: [tzeikob](https://github.com/tzeikob/sequel)
 * Where to get help: [Docker Community Forums](https://forums.docker.com/) [Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

## Supported tags and respective `Dockerfile` links
 * [5.7.32, 5.7, 5, latest](https://github.com/tzeikob/sequel/blob/main/5.7/Dockerfile)

## Quick reference (cont.)
 * Where to file issues: [bug tracker](https://github.com/tzeikob/sequel/issues)
 * Supported architectures: amd64

## What Sequel is?

Sequel is just a MySQL Server docker image made for trivial and development purposes only, it's purpose is to speed your workflow up and save you from the hassle of installing and setting up a server at your own. Each container you create from this image will have a clean MySQL Server up and running (unless you mount an data folder to `/var/lib/mysql`) and an already existing `root` user identified by the password `root`.

## How to use this image

### Start an image instance

Starting an instance is simple:

```
mkdir -p any-name
cd any-name

mkdir -p data
mkdir -p scripts

docker run -d --name any-name \
  -p 3306:3306 \
  -v $(pwd)/data:/var/lib/mysql \
  -v $(pwd)/scripts:/home/scripts/:rw \
  tzeikob/sequel:tag
```

where `any-name` is the name you want to assign to the container and tag is the tag specifying the version of the MySQL server. Note that the MySQL `root` user has been set by default to be identified by the password `root` and be accessible for connections from anywhere.

### Access the container's shell

The docker exec command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your mysql container:

```
docker exec -it any-name bash
```

### View the container's log file

The log is available through Docker's container log, you can tail of the file by using the `follow` flag:

```
docker logs -f -n all any-name
```

### Dumping databases to the host

Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the mysqld server. A simple way to ensure this is to use docker exec and run the tool from the same container, similar to the following:

```
docker exec any-name sh -c 'exec mysqldump --databases db-name -uroot -proot' > /path/on/your/host/db-name.sql
```

### Restoring data from dump files

For restoring data, you can use docker exec command with -i flag, similar to the following:

```
docker exec -i any-name sh -c 'exec mysql -uroot -proot' < /path/on/your/host/db-name.sql
```

## License
View [license](https://dev.mysql.com/doc/refman/5.7/en/preface.html) information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.