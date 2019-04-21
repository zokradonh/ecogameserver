Image for automated ECO image building
======

Set environment variable $TRIGGER_URL to specify the URL to be triggered.
```
docker run --rm -ti -e "TRIGGER_URL=https://cloud.docker.com/api/build/v1/source/SET_YOUR_URL" -v "eco-version-state:/versionwatch/state/" zokradonh/eco-versionwatch
``` 

Or in your docker-compose.yml file.
You do not need this image if you do not want to automate your own eco image.


# Volumes
Bind path `/versionwatch/state/` to some volume to keep track of last built version.