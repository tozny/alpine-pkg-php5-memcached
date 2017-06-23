# Copyright (C) 2016, Tozny, LLC.
# All Rights Reserved.
#

#######################
## PHP-libsodium     ##
#######################

# abuild source code: http://git.alpinelinux.org/cgit/abuild/tree/abuild.in

# Use alpine 3.3 since most php packages are built for 3.3 and not for 3.4
FROM alpine:3.3

MAINTAINER ben@tozny.com

WORKDIR /build

COPY APKBUILD /build

RUN apk add --no-cache alpine-sdk \
  libsodium \
  php \
  libsodium-dev \
  libc-dev \
  gcc \
  make \
  autoconf \
  php-dev \
  libmemcached \
  libmemcached-dev \
  zlib-dev

RUN mkdir -p /var/cache/distfiles && \
  chmod a+w /var/cache/distfiles && \
  echo 'builder  ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
  adduser -D -g "" builder && \
  addgroup builder abuild && \
  chown -R builder:abuild /build/ && \
  su builder -c "abuild-keygen -a -n" && \
  mkdir -p /pkgs && \
  chown -R builder:abuild /pkgs && \
  su builder -c "abuild -c -r -P /pkgs"
