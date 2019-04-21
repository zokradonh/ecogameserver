Image for automated ECO image building
======

Set environment variable $TRIGGER_URL to specify the URL to be triggered.
```
docker run -ti -e "TRIGGER_URL=https://cloud.docker.com/api/build/v1/source/SET_YOUR_URL" zokradonh/eco-versionwatch
``` 

Or in your docker-compose.yml file.
You do not need this image if you do not want to automate your own eco image.