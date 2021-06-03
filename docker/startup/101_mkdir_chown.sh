#!/bin/bash

echo "Creating log, node_modules, tmp/pids directories"
cd /home/app/myapp && mkdir -p log node_modules tmp/pids && touch tmp/restart.txt

# check ownership on /home/app/myapp
APP_UID=`stat --format '%u' /home/app/myapp`
APP_GID=`stat --format '%g' /home/app/myapp`

echo "Setting app user uid/gid to $APP_UID/$APP_GID"
groupmod -g $APP_GID app
usermod -u $APP_UID -g $APP_GID app

echo "chowning log, node_modules, tmp directories (typically created from volumes)"
cd /home/app/myapp && chown -R app log node_modules tmp
