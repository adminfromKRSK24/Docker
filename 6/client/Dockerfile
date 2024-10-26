FROM nginx

COPY ./nginx.conf /etc/nginx

RUN apt-get update && \
    apt install -y curl && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx"]