#! /bin/bash
# use this command to build the docker container

sudo docker build \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg BUILD_VERSION='1.0' \
  --build-arg VSC_REF='' \
  --tag speedtest-cron:1.0 .
