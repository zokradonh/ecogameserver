#!/bin/bash

# populate with missing default config files 
cp -n /app/DefaultConfigs/* /app/Configs/

# TODO config with environment variables
#for envar in ${!ECO_*}

# start server
exec mono /app/EcoServer.exe -nogui