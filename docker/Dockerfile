FROM altcloud/nginx:latest

LABEL maintainer="a.sarajkin@ts58.ru"

ENV TZ=Europe/Moscow

RUN rm /var/www/html/index.html

COPY ./html/ /var/www/html/

RUN service nginx start