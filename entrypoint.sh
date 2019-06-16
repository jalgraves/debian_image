#!/bin/sh

sleep 2

printf "\n* Starting ${SITE_NAME} App *\n\n"
if [ -d '/app/log' ]
then
    rm -rf /app/log/
    mkdir /app/log
    touch /app/log/${SITE_NAME}.log
else
    mkdir /app/log
    touch /app/log/${SITE_NAME}.log
fi

filebeat run &

cd /app/
sleep 1
gunicorn base.wsgi -b 0.0.0.0:8000 || \
printf "Error Starting ${SITE_NAME} App"
