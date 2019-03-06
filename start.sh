#!/bin/bash

# populate with missing default config files 
cp -n /app/DefaultConfigs/* /app/Configs/

exec mono /app/EcoServer.exe -nogui