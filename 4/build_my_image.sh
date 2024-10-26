#! /bin/bash

ask1="Y"
ask2="y"
name_image="dfortune/nginx"

# docker ps -a | grep "pattern" | awk '{print $3}' | xargs docker rmi
# docker images -a | grep "dfortune/nginx" | awk '{print $3}' | xargs docker rmi

DOCKER_SCAN_SUGGEST=false docker build -t $name_image:latest .
docker run -d -p 80:81 -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf $name_image

echo -n "Открыть в браузере? Y/N: "
read ask
if [[ ( "$ask" = "$ask1" ) || ( "$ask" = "$ask2" ) ]]
then
    open -a "Google Chrome" http://localhost:80
fi