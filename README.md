[![Docker Pulls](https://img.shields.io/docker/pulls/zokradonh/ecogameserver.svg)](https://hub.docker.com/r/zokradonh/ecogameserver/)
[![](https://images.microbadger.com/badges/version/zokradonh/ecogameserver.svg)](https://microbadger.com/images/zokradonh/ecogameserver "Get your own version badge on microbadger.com")

### Deprecated. Please use official image strangeloopgames/eco-game-server. Just replace `zokradonh/ecogameserver` with `strangeloopgames/eco-game-server`
Check https://hub.docker.com/r/strangeloopgames/eco-game-server/tags for the latest tags.

Docker ECO Game Server
=============

A docker image for the ECO game. (http://www.strangeloopgames.com/eco/)
According to ECO EULA you need to own a client ECO license to run an ECO server.

Features
===========
- graceful stop: `docker stop` triggers world save. (Which is now an integrated ECO feature)
- true automated build: watch script on my server that checks new eco version every hour
- missing something? Create a GitHub issue.

Usage
==========

To start server
```
docker run -d -p 3000:3000/udp -p 3001:3001/tcp -v /yourconfig:/app/Configs -v /yourworldstorage:/app/Storage zokradonh/ecogameserver
```

Replace `/yourconfig` and `/yourworldstorage` with the path on your host system.

If this is your first ECO server and you are not migrating then before starting the server I recommend running:

```
docker run --rm -v /yourconfig:/app/Configs zokradonh/ecogameserver /app/generate_config.sh
```
this populates your `/yourconfig` volume with default config files. Then you can easily edit them according to your needs. Afterwards you start the server with the command on top.
You can also use this command in combination with docker compose.

Docker Compose
========
Create file `docker-compose.yml` like in `docker-compose-example.yml`:

This saves the config and storage folders in volumes. You can also use absolute host paths instead of `worldsave` or `config`.
You can adjust the `stop_grace_period` time if your world is very big and needs longer for saving the world. You can see the needed time with `docker-compose logs`.

To start server run in the same directory:
```
docker-compose up -d
```
To update game server type:
```
docker-compose stop && docker-compose pull && docker-compose up -d
```
This stops the server, pulls the new image from hub.docker.com, removes the old container and creates a new container with updated version.
Of course, this does not remove your savegame/world.

Custom Building
========
If you don't want to rely on my hourly script to trigger a new build after new ECO release, you can build your own image with the following docker-compose.yml:
```
version: '3'

services:

  server:
    build: https://github.com/zokradonh/ecogameserver.git
    stop_grace_period: 20s
    ports:
      - 3000:3000/udp
      - 3001:3001/tcp
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

Planned Features
==========
- drop all unnecessary container capabilities
