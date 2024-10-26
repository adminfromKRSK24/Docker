FROM nginx:bullseye

# LABEL name="doduofor_fortune"

LABEL maintainer="doduofor@student.21-school.ru"

ENV TZ=Asia/Novosibirsk
  
COPY ./nginx/nginx.conf /etc/nginx/
COPY ./server.c /home/

# RUN set -x \
# # create nginx user/group first, to be consistent throughout docker variants
#     && addgroup --system --gid 101 nginx \
#     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx, user, , , " --shell /bin/false --uid 101 nginx \
#     && apt-get update \
#     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates \

# # RUN useradd -r -s /bin/bash -g nginx doduofor \
# #     && chmod -R 666 /bin/bash 
# #     && chown -R doduofor:nginx /etc/nginx/ \
# #     && chown -R doduofor:nginx /var

# # RUN set -x && useradd -d /home/docker -m -s /bin/bash docker 

RUN apt-get update \
    && apt-get install -y   gcc \
                            supervisor \
                            spawn-fcgi \
                            libfcgi-dev \
    && gcc /home/server.c -lfcgi -o /home/server \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod u-s usr/bin/chfn \
    && chmod u-s usr/bin/gpasswd \
    && chmod u-s bin/su \
    && chmod u-s bin/umount \
    && chmod g-s sbin/unix_chkpwd \
    && chmod g-s usr/bin/chage \
    && chmod u-s usr/bin/passwd \
    && chmod g-s usr/bin/wall \
    && chmod u-s usr/bin/chsh \
    && chmod g-s usr/bin/expiry \
    && chmod u-s bin/mount \
    && chmod u-s usr/bin/newgrp 

# USER docker

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:8080 || exit 1
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

