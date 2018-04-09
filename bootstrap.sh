#!/bin/bash

# populate with missing default config files 
cp -n /app/DefaultConfigs/* /app/Configs/

pipe=$(mktemp -u)
mkfifo $pipe

#trap "echo \"SIGTERM raised\"" SIGTERM
trap "printf \"exit\n\" >> $pipe" SIGTERM

# start server
cd /app
cat $pipe | mono /app/EcoServer.exe -nogui &
PID=$!
# wait for trap or exit
wait $PID
# wait for graceful exit (saving world)
START=$(date +%s)
wait $PID
EXIT_STATUS=$?
END=$(date +%s)
DIFF=$(($END - $START))

echo "Server gracefully shutdown in $DIFF seconds."

rm $pipe
exit $EXIT_STATUS