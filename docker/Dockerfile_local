FROM ruby:2.5-alpine

MAINTAINER evait security GmbH <tech@evait.de>

COPY Gemfile Gemfile.lock /

ENV BUILD_PACKAGES="curl-dev git curl ruby-dev git nmap@edge" \
    NMAP_PACKAGES="nmap@edge nmap-doc@edge nmap-ncat@edge nmap-nping@edge nmap-nselibs@edge nmap-scripts@edge" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev" \
    PACKAGES="nodejs graphviz yarn postgresql-dev openssl" \
    RAILS_ENV="development"

RUN \
  apk update && apk add build-base && \

  echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main/' >> /etc/apk/repositories && \
  apk --update --upgrade add $BUILD_PACKAGES $NMAP_PACKAGES $PACKAGES $DEV_PACKAGES && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \

  # Clean up
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem && \

  mkdir -p /usr/src/app/envizon && \

  cd /usr/src/app/envizon && \
  mv /Gemfile.lock /usr/src/app/envizon && \
  mv /Gemfile /usr/src/app/envizon && \
  mkdir .ssl && \
  bundle install

COPY docker/entrypoint_local.sh /
COPY docker/entrypoint_development.sh /

RUN chmod +x /entrypoint_local.sh
RUN chmod +x /entrypoint_development.sh

WORKDIR /usr/src/app/envizon

EXPOSE 3000
CMD /entrypoint_local.sh
