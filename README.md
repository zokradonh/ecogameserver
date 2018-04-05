Docker ECO Game Server
=============

A docker image for the ECO game. (http://www.strangeloopgames.com/eco/)
You need an ECO license to run this server.

To start server
```
docker run -d -p 2999:2999/udp -p 3000-3001:3000-3001 -v /yourconfig:/app/Configs -v /yourworldstorage:/app/Storage zokradonh/ecogameserver
```

Replace `/yourconfig` and `/yourworldstorage` with the path on your host system.

If this is your first ECO server and you are not migrating then before starting the server I recommend running:

```
docker run --rm -v /yourconfig:/app/Configs zokradonh/ecogameserver /app/generate_config.sh
```
this populates your `/yourconfig` volume with default config files. Then you can easily edit them according to your needs. Afterwards you start the server with the command on top.
You can also use this command in combiation with docker compose.

Docker Compose
========
Create file `docker-compose.yml` with the following contents:
```
version: '3'

services:

  server:
    image: zokradonh/ecogameserver
    ports:
      - 2999:2999/udp
      - 3000-3001:3000-3001
    volumes:
      - ./yourconfig:/app/Configs
      - ./yourworldstorage:/app/Storage
```
This saves the config and storage folders in the same folder of docker-compose.yml. You can also use absolute paths instead of `./`. 

To start server run in the same directory:
```
docker-compose up -d
```
To update game server type:
```
docker-compose stop && docker-compose pull && docker-compose up -d
```
This stops the server, pulls the new image from hub.docker.com, removes the old container and creates a new container with updated version.
As long as automatic build triggering is not implemented I need to manually trigger the build on hub.docker.com for a new ECO release. If I am late this command will not bring any new version.

Custom Building
========
If you don't want to rely on me to trigger a new build after new ECO release, you can build your own image with the following docker-compose.yml:
```
version: '3'

services:

  server:
    build: https://github.com/ZokRadonh/ecogameserver.git
    ports:
      - 2999:2999/udp
      - 3000-3001:3000-3001
    volumes:
      - ./yourconfig:/app/Configs
      - ./yourworldstorage:/app/Storage
```
And to update use the following commands:
```
docker-compose stop && docker-compose --no-cache build && docker-compose up -d
```
This stops the server, builds the new image from scratch, recreates the container and starts it.
We need to use `--no-cache` since the docker daemon does not know that there is a new ECO release.

Planned features
==========
- graceful stop on docker stop
- ~~change config files via environment variables~~
- automated trigger of hub.docker.com build on new ECO release