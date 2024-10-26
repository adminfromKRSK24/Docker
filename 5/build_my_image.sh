#! /bin/bash

ask1="Y"
ask2="y"
name_image="dfortune_nginx"

# docker ps -a | grep "pattern" | awk '{print $3}' | xargs docker rmi
# docker images -a | grep "dfortune/nginx" | awk '{print $3}' | xargs docker rmi
docker stop my_nginx && docker rm my_nginx
docker rmi $name_image

#DOCKER_SCAN_SUGGEST=false
if [ $DOCKER_CONTENT_TRUST -eq 1 ]; then export DOCKER_CONTENT_TRUST=0; fi
docker build -t $name_image .
docker run --health-cmd='curl -sS http://127.0.0.1:8080 || echo 1' \
    --health-timeout=10s \
    --health-retries=3 \
    --health-interval=5s \
    --name my_nginx \
    -d -p 80:81 -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf $name_image 

export DOCKER_CONTENT_TRUST=1
echo -n "Открыть в браузере? Y/N: "
read ask
if [[ ( "$ask" = "$ask1" ) || ( "$ask" = "$ask2" ) ]]
then
    if ! [[ $OSTYPE = "linux-gnu" ]]
    then
	open -a "Google Chrome" http://localhost:80
    else
	xdg-open http://localhost:80
    fi
fi
dockle -i CIS-DI-0010 -i CIS-DI-0001 -i DKL-DI-0006 $name_image