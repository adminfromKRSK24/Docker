#! /bin/bash


Color_G="\033[92m"
Color_R="\033[91m"
Color_Cl="\033[0m"

ask1="Y"
ask2="y"

docker run -d -p 82:82 nginx >> /dev/null;
sleep 1
if [ $? -eq 0 ]; then echo -e "$Color_G COMPLED$Color_Cl  Контейнер запущен"; else echo -e "$Color_R FAIL$Color_Cl  Сервер не скопирован"; fi;

if [ $? -eq 0 ]
then
    name_container=`docker ps | awk 'NR =='2'{print $12}'`
    docker cp ./server.c $name_container:/home 2>/dev/null; 
        if [ $? -eq 0 ]; then echo -e "$Color_G COMPLED$Color_Cl  Сервер скопирован"; else echo -e "$Color_R FAIL$Color_Cl  Сервер не скопирован"; fi;
    docker cp ./nginx.conf $name_container:/etc/nginx 2>/dev/null; 
        if [ $? -eq 0 ]; then echo -e "$Color_G COMPLED$Color_Cl  Файл конфигурации скопирован"; else echo -e "$Color_R FAIL$Color_Cl  Файл конфигурации не скопирован"; fi;
    docker exec -it $name_container bash -c "nginx -s reload 2>/dev/null" 2>/dev/null; 
        if [ $? -eq 0 ]; then echo -e "$Color_G COMPLED$Color_Cl  Nginx перезапущен"; else echo -e "$Color_R FAIL$Color_Cl  Nginx не перезапущен"; fi;
else
    echo -e "$Color_R FAIL$Color_Cl ";
fi;

chmod +x ./install_lib.sh
./install_lib.sh $name_container

docker exec -it $name_container bash -c "spawn-fcgi -p 8080 /home/server" >>/dev/null
if [ $? -eq 0 ]; then echo -e "$Color_G COMPLED$Color_Cl  Сервер запущен"; else echo -e "$Color_R FAIL$Color_Cl Что-то пошло не так!"; fi;

echo -n "Открыть в браузере? Y/N: "
read ask
if [[ ( "$ask" = "$ask1" ) || ( "$ask" = "$ask2" ) ]]
then
    open -a "Google Chrome" http://localhost:82
fi

