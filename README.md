# docker-rails - Docker image for Rails development

[![Version](https://img.shields.io/github/tag/anamba/docker-rails.svg?maxAge=360)](https://github.com/anamba/docker-rails/releases/latest)
[![License](https://img.shields.io/github/license/anamba/docker-rails.svg)](https://github.com/anamba/docker-rails/blob/master/LICENSE)

Docker Hub: [anamba/rails-dev](https://hub.docker.com/r/anamba/rails-dev/)

Based on Phusion's excellent, developer-friendly [passenger-docker](https://github.com/phusion/passenger-docker) image (based on 20.04 LTS aka Focal). Includes fullstaq ruby, which offers improved performance and reduced memory usage.

Primary use cases:

* CI (e.g. Bitbucket Pipelines)
* Local development, VS Code Dev Containers

## Contents

Includes:

* MRI Ruby 3.2.2 + Rubygems 3.5.6
* MRI Ruby 3.1.4 + Rubygems 3.5.6
* MRI Ruby 3.0.6 + Rubygems 3.5.6
* MRI Ruby 2.7.8 + Rubygems 3.4.22
* MRI Ruby 2.6.9 + Rubygems 3.4.22
* Fullstaq Ruby 3.2.2
* Fullstaq Ruby 3.1.4
* Fullstaq Ruby 3.0.6
* Fullstaq Ruby 2.7.8
* Passenger 6.0.20
* Node 16 + yarn
* rvm stable

Working dir is `/home/app/myapp` (user is `app`).

## Versioning

Versioning originally followed passenger-docker, but no longer.

1.4.3: Reverted base image to ensure we use Node 16
1.4.2: do not use
1.4.1: Added Ruby 3.2
1.4: Added Ruby 3.1, removed 2.5
1.3: Added Ruby 3.0, removed 2.4; Node 14 -> 16
1.2: Bionic -> Focal; Node 12 -> 14
1.1: Added Ruby 2.7, removed 2.3; includes latest bundler out of the box
1.0: Original release

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
    image: anamba/rails-dev:1.4
    volumes:
      - ./:/home/app/myapp
      - /home/app/myapp/log                        # you probably want to keep log and tmp in volumes
      - /home/app/myapp/tmp                        # (especially if your working copy is in Dropbox, etc.)
      - gems:/usr/local/rvm/gems                   # if you want to keep a single gem cache
  db:
    image: mysql:8.0
    volumes:
      - /var/lib/mysql

  redis:
    image: redis:6.0

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
docker build --no-cache -t anamba/rails-dev:1.4 .

# optional: test and make sure everything is installed as expected
docker run -it anamba/rails-dev:1.4 bash -l

docker tag anamba/rails-dev:1.4 anamba/rails-dev:1.4.3

docker push anamba/rails-dev:1.4
docker push anamba/rails-dev:1.4.3
```
