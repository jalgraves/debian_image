#!/bin/sh

sleep 2

printf "\n* Starting ${SITE_NAME} App *\n\n"
if [ -d '/app/log' ]

filebeat run &

cd /app/
sleep 1
gunicorn base.wsgi -b 0.0.0.0:8000 || \
printf "Error Starting ${SITE_NAME} App"
