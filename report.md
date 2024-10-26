# Simple Docker

## Подготовка
* Устанавливаю ssh-соединение
```bash
ssh -p2222 localhost@student
````
<img src="../misc/images_ex/01.png"/> <br/>
* Обновляю ОС
```bash
sudo apt update && sudo apt upgrade
```
<img src="../misc/images_ex/02-0.png"/> <br/>
<img src="../misc/images_ex/02-1.png"/> <br/>
* Устанавливаю Docker
```bash
sudo apt install docker.io
```
<img src="../misc/images_ex/03.png"/> <br/>
* Для удобства добавляю права докеру запускаться из под юзера и права доступа к сокету
```bash
sudo usermod -aG docker $USER # дали права докеру запускаться из под юзера
sudo chmod +666 /var/run/docker.sock # даем права доступа к докер сокету
```
<img src="../misc/images_ex/04.png"/> <br/>

## Part 1. Готовый докер

== Решение ==

* Скачиваю официальный докер образ с nginx 
```bash
docker pull nginx
```
<img src="../misc/images_ex/1-1.png"/> <br/>
* Проверить наличие докер образа 
```bash
docker images
```
<img src="../misc/images_ex/1-2.png"/> <br/>
* Запускаю докер образ через 
```bash
docker run -d nginx
```
* Проверяю докер образ через
```bash
docker ps
```
<img src="../misc/images_ex/1-3.png"/> <br/>
* Смотрю информацию о контейнере с помощью
```bash
docker inspect 65c33436c48b # с помощью grep фильтрую
````
<img src="../misc/images_ex/1-4.png"/> <br/>
* Останавливаю докер образ и проверяю через
```bash
docker stop 65c33436c48b
docket ps
```
<img src="../misc/images_ex/1-5.png"/> <br/>

* Запускаю докер с замапленными портами 80 и 443 на локальную машину через команду
```bash
docker run -d -p 80:80 nginx
docker run -d -p 443:80 nginx
```
<img src="../misc/images_ex/1-6.png"/> <br/>
<img src="../misc/images_ex/1-7.png"/> <br/>

## Part 2. Операции с контейнером

== Решение ==

* Смотрю запущенные контейнеры, чтобы посмотреть имя 

```bash
docker ps
```
<img src="../misc/images_ex/2-1.png"/> <br/>

* Открываю контейнер для просмотра содержимого
```bash
docker exec -it affectionate_booth bash
```
<img src="../misc/images_ex/2-2.png"/> <br/>

* Смотрю конфигурационный файл nginx.conf внутри докер контейнера
```bash
cat /etc/nginx/nginx.conf
```
<img src="../misc/images_ex/2-3.png"/> <br/>

* Смотрю файл default.conf внутри докер контейнера 
```bash
    cat /etc/nginx/conf.d/default.conf # смотрю файл для понимания структуры location
```

<img src="../misc/images_ex/2-4.png"/> <br/>

* Создаю на локальной машине файл nginx.conf 
```bash
    touch /home/student/nginx.conf
```

* Настраиваю в нем по пути /status отдачу страницы статуса сервера nginx
```bash

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # include /etc/nginx/conf.d/*.conf;
    server {
        listen       80;
        listen  [::]:80;
        server_name  localhost;

        #access_log  /var/log/nginx/host.access.log  main;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /status {
            proxy_pass http://localhost:80/;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }
}
```

* Копирую созданный файл nginx.conf внутрь докер образа через команду docker cp
```bash
    docker cp ./nginx.conf funny_elbakyan:/etc/nginx
```

<img src="../misc/images_ex/2-5.png"/> <br/>

* Перезапускаю nginx внутри докер образа
```bash
    docker exec -it funny_elbakyan bash
    nginx -s reload # эту команду уже внутри докер контейнера
```

<img src="../misc/images_ex/2-6.png"/> <br/>

* Проверяю, что по адресу localhost:80/status отдается страничка со статусом сервера nginx
```bash
    https://localhost:80/status # эту команду ввожу в терминале vs code
```
* Устанавливается соединение с docker контейнером, захожу через браузер

<img src="../misc/images_ex/2-7.png"/> <br/>

* Экспортирую контейнер в файл my_nginx.tar
```bash
docker export compassionate_borg > my_nginx.tar
docker export --output="my_nginx.tar" compassionate_borg
```

<img src="../misc/images_ex/2-8.jpg"/> <br/>

* Останавливаю контейнер
```bash
docker stop compassionate_borg
```

<img src="../misc/images_ex/2-9.jpg"/> <br/>

* Удаляю изображение с помощью, docker rmi [image_id|repository]не удаляя сначала контейнер
```bash
docker images # вывожу образ для просмотра IMAGE ID
docker rmi -f 6efc10a0510f # удаляю образ
docker images -a # смотрю, что образ удален
```

<img src="../misc/images_ex/2-10.jpg"/> <br/>

* Удаляю остановленный контейнер
```bash
docker ps -a # вывожу все контейнеры, чтобы посмотреть CONTAINER ID
docker rm 7fcb336c734c # удаляю
docker ps -a # проверяю
```

* Импортирую контейнер обратно с помощью команды import
```bash
docker import -c 'CMD ["nginx", "-g", "daemon off;"]' my_nginx.tar my_nginx
```
* Запускаю импортированный контейнер
```bash
docker run -d -p 80:80 my_nginx
```
<img src="../misc/images_ex/2-11.jpg"/> <br/>

* Проверяю, что localhost:80/status возвращает страницу состояния сервера nginx 

<img src="../misc/images_ex/2-12.jpg"/> <br/>
<img src="../misc/images_ex/2-13.jpg"/> <br/>