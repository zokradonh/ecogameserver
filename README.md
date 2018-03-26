Docker ECO Game Server
=============

A docker image for the ECO game. (http://www.strangeloopgames.com/eco/)

To start server

```
docker run -d -p 2999:2999/udp -p 3000-3001:3000-3001 -v /yourconfig:/app/Configs -v /yourworldstorage:/app/Storage zokradonh/ecogameserver
```

Replace `/yourconfig` and `/yourworldstorage` with the path on your host system.

If this is your first ECO server and you are not migrating then before starting the server I would recommend running:

```
docker run --rm -v /yourconfig:/app/Configs zokradonh/ecogameserver /app/generate_config.sh
```

this populates your `/yourconfig` volume with default config files. Then you can easily edit them according to your needs.



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
      - ./data/Configs:/app/Configs
      - ./data/Storage:/app/Storage
```
Run in the same directory
```
docker-compose up -d
```
To update game server type:
```
docker-compose stop && docker-compose up --pull -d
```
This stops the server, pulls the new image from hub.docker.com, removes the old container and creates a new container with updated version.


Planned features
==========
- change config files via environment variables
- automated trigger of hub.docker.com build on new ECO release