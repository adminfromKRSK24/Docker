FROM nginx:latest

LABEL name="doduofor_fortune"

ENV TZ=Asia/Novosibirsk

COPY ./nginx/nginx.conf /etc/nginx/
COPY ./server.c /home/

RUN apt-get update \
    && apt-get install -y   gcc \
                            supervisor \
                            spawn-fcgi \
                            libfcgi-dev \
    && gcc /home/server.c -lfcgi -o /home/server \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

