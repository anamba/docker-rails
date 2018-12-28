# docker-rails - Docker image for Rails development

[![Version](https://img.shields.io/github/tag/anamba/docker-rails.svg?maxAge=360)](https://github.com/anamba/docker-rails/releases/latest)
[![License](https://img.shields.io/github/license/anamba/docker-rails.svg)](https://github.com/anamba/docker-rails/blob/master/LICENSE)

Docker Hub: [anamba/rails-dev](https://hub.docker.com/r/anamba/rails-dev/)

Based on Phusion's excellent, developer-friendly [passenger-docker](https://github.com/phusion/passenger-docker) image (based on 18.04 LTS aka Bionic).

## Contents

Includes:

* Ruby 2.5.3 + Rubygems 2.7.8
* Ruby 2.6.0 + Rubygems 3.0.1
* Passenger 6.0.0

Working dir is `/home/app/myapp` (user is `app`).

## Versioning

Tracks passenger-docker versions.

## How to use

Add to Dockerfile (optional):
```
COPY /docker/conf/nginx-vhost.conf.template /etc/nginx/
```

Example `docker-compose.yml`:
```yaml
version: '3'

services:
  web:
    image: anamba/rails-dev:1.0                    # latest 1.0.x version
    volumes:
      - ./:/home/app/myapp:delegated               # NOTE: :delegated is a Docker for Mac feature
      - node_modules:/home/app/myapp/node_modules  # keep node_modules off your local filesystem
      - log:/home/app/myapp/log                    # you may also want to keep log and tmp in volumes
      - tmp:/home/app/myapp/tmp                    # (especially if your working copy is in Dropbox, etc.)
      - gems:/usr/local/rvm/gems                   # if you want to keep a single gem cache
  db:
    image: mariadb:10.3
    volumes:
      - db-data:/var/lib/mysql
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: 1

  redis:
    image: redis:4.0-32bit

volumes:
  node_modules:
  log:
  tmp:
  db-data:
  gems:
    external: true
```

From there, you can run `docker-compose up` to start the containers, then, in a separate terminal:
```bash
docker-compose exec -u app web bash          # get a user shell
docker-compose exec web bash                 # get a root shell
```

You'll want to create aliases or simple shell scripts to save yourself some typing.

## Development

(notes for myself)

```bash
docker build -t anamba/rails-dev:latest .
docker tag anamba/rails-dev:latest anamba/rails-dev:1.0.1.1
docker tag anamba/rails-dev:latest anamba/rails-dev:1.0
docker push anamba/rails-dev
```
