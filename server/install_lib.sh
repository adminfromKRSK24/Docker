#! /bin/bash

docker exec -it $1 bash -c "apt update && apt install -y gcc spawn-fcgi libfcgi-dev >>/dev/null" >>/dev/null
docker exec -it $1 bash -c "gcc /home/server.c -lfcgi -o /home/server >>/dev/null" >>/dev/null