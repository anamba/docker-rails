# docker-rails - Docker image for Rails development

[![Version](https://img.shields.io/github/tag/anamba/docker-rails.svg?maxAge=360)](https://github.com/anamba/docker-rails/releases/latest)
[![License](https://img.shields.io/github/license/anamba/docker-rails.svg)](https://github.com/anamba/docker-rails/blob/master/LICENSE)

Docker Hub: [anamba/rails-dev](https://hub.docker.com/r/anamba/rails-dev/)

Based on Phusion's excellent, developer-friendly [passenger-docker](https://github.com/phusion/passenger-docker) image (based on 18.04 LTS aka Bionic).

## Contents

Includes:

* Ruby 2.6.3 + Rubygems 3.0.3 ([security release](https://blog.rubygems.org/2019/03/05/security-advisories-2019-03.html))
* Ruby 2.5.5 + Rubygems 3.0.3
* Ruby 2.4.6 + Rubygems 3.0.3
* Ruby 2.3.8 + Rubygems 3.0.3
* Node 10
* Passenger 6.0.2

Working dir is `/home/app/myapp` (user is `app`).

## Versioning

Tracks passenger-docker versions.

## How to use

Add to nginx vhost steps to Dockerfile (optional):
```
RUN rm -f /etc/nginx/sites-enabled/default
COPY /docker/conf/nginx-vhost.conf.template /etc/nginx/
```

Example `docker-compose.yml`:
```yaml
version: '3'

services:
  web:
    image: anamba/rails-dev:1.0
    volumes:
      - ./:/home/app/myapp:delegated               # NOTE: :delegated is a Docker for Mac feature
      - /home/app/myapp/log                        # you probably want to keep log and tmp in volumes
      - /home/app/myapp/tmp                        # (especially if your working copy is in Dropbox, etc.)
      - gems:/usr/local/rvm/gems                   # if you want to keep a single gem cache
  db:
    image: mariadb:10.4
    volumes:
      - /var/lib/mysql
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: 1

  redis:
    image: redis:5.0-32bit

volumes:
  gems:
    external: true
```

From there, you can run `docker-compose up` to start the containers, then, in a separate terminal:
```bash
docker-compose exec -u app web bash -l  # user login shell
docker-compose exec web bash -l         # root login shell
```

You'll want to create aliases or simple shell scripts to save yourself some typing.

## Development

(notes for myself)

```bash
docker build -t anamba/rails-dev:latest .
docker tag anamba/rails-dev:latest anamba/rails-dev:1.0.6
docker tag anamba/rails-dev:latest anamba/rails-dev:1.0
docker push anamba/rails-dev
```
