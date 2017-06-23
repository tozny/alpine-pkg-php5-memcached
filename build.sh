#! /bin/bash

# This build script creates a docker container to build php-libsodium.
# It also copies out the php-libsodium*.apk package that the container creates
# into the current directory for use in the api docker container
os=$(uname)
if [ "$os" == 'Darwin' ]; then
  # osx
  parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
elif [ "$os" == 'Linux' ]; then
  # linux
  parent_path=$(dirname $(readlink -f $0))
else
  # not linux or osx
  echo "No OS found"
  exit 1
fi

cd $parent_path
apk=$(find . -name *.apk)

if [ -z $apk ]; then
  # if we can't find the libsodium apk package, we need to build it.
  # otherwise we can skip this build step
  tag="php-memcached"
  docker build -t $tag $parent_path
  id=$(docker run -d $tag yes)
  pkg=$(docker exec $id find /pkgs/ -name *.apk | grep -v dev | grep -v doc)
  docker kill $id
  docker cp $id:$pkg $parent_path
fi
