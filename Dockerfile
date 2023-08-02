# See https://github.com/phusion/passenger-docker/blob/master/CHANGELOG.md for a list of version numbers.
FROM phusion/passenger-full:2.5.1
LABEL maintainer="bbsoftware@biggerbird.com"

# Set up 3rd party repos
RUN apt-get update; apt-get install ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update

# Upgrade preinstalled packages
RUN apt-get upgrade -y -o Dpkg::Options::="--force-confnew"

# Install common dependencies
RUN apt-get install -y nodejs yarn
RUN apt-get install -y mysql-client shared-mime-info tzdata
RUN apt-get install -y gettext # for envsubst
RUN apt-get autoremove -y

# Update rvm
RUN /usr/local/rvm/bin/rvm get stable
RUN /usr/local/rvm/bin/rvm cleanup all

# Update rubygems and install/update bundler
RUN bash -l -c "rvm use 3.2.2 --install && gem update --system && gem install bundler"
RUN bash -l -c "rvm use 3.1.4 --install && gem update --system && gem install bundler"
RUN bash -l -c "rvm use 3.0.6 --install && gem update --system && gem install bundler"
RUN bash -l -c "rvm use 2.7.8 --install && gem update --system && gem install bundler"

# Add fullstaq ruby repo and install target versions
RUN curl -SLfo /etc/apt/trusted.gpg.d/fullstaq-ruby.asc https://raw.githubusercontent.com/fullstaq-labs/fullstaq-ruby-server-edition/main/fullstaq-ruby.asc
RUN echo "deb https://apt.fullstaqruby.org ubuntu-20.04 main" > /etc/apt/sources.list.d/fullstaq-ruby.list
RUN apt-get update
# RUN apt-get install -y fullstaq-ruby-common
# RUN apt-get install -y fullstaq-ruby-3.2.2-jemalloc
# RUN apt-get install -y fullstaq-ruby-3.1.4-jemalloc
# RUN apt-get install -y fullstaq-ruby-3.0.6-jemalloc
# RUN apt-get install -y fullstaq-ruby-2.7.8-jemalloc

# # Enable nginx
# RUN rm -f /etc/service/nginx/down
# COPY docker/services/nginx /etc/service/nginx/run

# # Helpful startup scripts (you can rm them in your own Dockerfile if you don't need them)
# RUN mkdir -p /etc/my_init.d
# COPY docker/startup/101_mkdir_chown.sh /etc/my_init.d/
# # COPY docker/startup/201_bundler.sh /etc/my_init.d/
# # COPY docker/startup/211_yarn.sh /etc/my_init.d/

# # Post-build clean up
# RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

# Expose port 80 to the Docker host, so we can access it from the outside (remember to publish it using `docker run -p`).
EXPOSE 80

WORKDIR /home/app/myapp

# Run this to start all services (if no command was provided to `docker run`)
CMD ["/sbin/my_init"]
