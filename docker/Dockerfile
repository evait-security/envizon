FROM ruby:2.5-alpine

MAINTAINER evait security GmbH <tech@evait.de>

ENV BUILD_PACKAGES="curl-dev git curl ruby-dev git nmap@edge" \
    NMAP_PACKAGES="nmap@edge nmap-doc@edge nmap-ncat@edge nmap-nping@edge nmap-nselibs@edge nmap-scripts@edge" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev" \
    PACKAGES="nodejs graphviz yarn postgresql-dev openssl" \
    RAILS_ENV="production"

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

  mkdir -p /usr/src/app && \
  cd /usr/src/app && \
  git clone https://github.com/evait-security/envizon.git && \
  cd envizon && \
  mkdir .ssl && \
  bundle install

RUN \
  cp /usr/src/app/envizon/docker/entrypoint.sh /entrypoint.sh && \
  chmod +x /entrypoint.sh

WORKDIR /usr/src/app/envizon

EXPOSE 3000
CMD /entrypoint.sh
