FROM ruby:2.7-alpine

ENV BUILD_PACKAGES="curl-dev git curl ruby-dev git nmap@edge" \
    NMAP_PACKAGES="nmap@edge nmap-doc@edge nmap-ncat@edge nmap-nping@edge nmap-nselibs@edge nmap-scripts@edge" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev less" \
    PACKAGES="nodejs graphviz yarn libpq postgresql-dev postgresql-client openssl imagemagick mariadb-dev mariadb-connector-c-dev" \
    RAILS_ENV="production"

RUN \
  apk update && apk add build-base && \
  echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main/' >> /etc/apk/repositories && \
  apk --update --upgrade add $BUILD_PACKAGES $NMAP_PACKAGES $PACKAGES $DEV_PACKAGES && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  gem install bundler:2.2.6 && \
  bundle config --global build.nokogiri "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  # Clean up
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem && \
  mkdir -p /usr/src/app && \
  cd /usr/src/app && \
  git clone https://github.com/evait-security/envizon.git && \
  cd envizon && \
  mkdir .ssl && \
  bundle config set --local without 'test:development' && \
  bundle install

RUN \
  apk --no-cache del postgresql-dev postgresql-client && \
  # add edge versions for pg_dump etc.
  apk --no-cache add libpq@edge postgresql-dev@edge postgresql-client@edge

RUN \
  cp /usr/src/app/envizon/docker/envizon_prod/entrypoint.sh /entrypoint.sh && \
  chmod +x /entrypoint.sh

WORKDIR /usr/src/app/envizon

EXPOSE 3000
CMD /entrypoint.sh
