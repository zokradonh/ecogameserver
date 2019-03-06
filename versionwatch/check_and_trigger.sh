#!/bin/bash

# vercomp () is licensed under CC BY-SA 3.0 by Dennis Williamson
# https://stackoverflow.com/a/4025065
# https://creativecommons.org/licenses/by-sa/3.0/
vercomp () {
    if [[ $1 == "$2" ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

latestVersion=$( aws --no-sign-request s3 ls eco-releases | grep -E -e "EcoServer_v[0-9.]*-beta.zip" | sort -n | tail -1 | awk '{print $4}' | sed -r 's#.+_v([0-9.]+).+#\1#' )

lastKnown=$( cat /versionwatch/state/latest )

vercomp "$latestVersion" "$lastKnown"

if [[ $? == 1 ]]
then
    # there is a newer version
    # cache version
    echo "$latestVersion" > /versionwatch/state/latest
    echo "Found new version ($latestVersion), triggering new build"
    # trigger build
    curl -H "Content-Type: application/json" --data '{"build": true}' -X POST "https://registry.hub.docker.com/u/zokradonh/ecogameserver/trigger/$TRIGGER_TOKEN/"
fi