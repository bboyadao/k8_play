#!/bin/bash
APP_PORT=${PORT:-80}
cd /app
exec gunicorn --worker-tmp-dir /dev/shm chuthe.wsgi:application --bind "0.0.0.0:${APP_PORT}"