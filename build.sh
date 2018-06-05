#!/bin/sh

set -e
set -v
set -x

##
docker build -f Dockerfile.builder -t frr:centos .
id=`docker create frr:centos`
docker cp ${id}:/rpms/ .
docker rm $id
docker rmi frr:centos
