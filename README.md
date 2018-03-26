Docker ECO Game Server
=============

A docker image for the ECO game.

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



docker-compose.yml
========

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