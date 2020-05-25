# speedtest
Run speedtest for Zabbix in a container. 

One cycle of speedtest-cli takes about 25 seconds. Most obvious solution would be to run speedtest-cli as a UserParameter from the Zabbix agent. This however is not ideal as duringthis time, the agent process is waiting. In order to make this work, agent configuration ZBX_TIMEOUT has to be increased 3 seconds (=default) to 30 seconds. Same also on the Zabbix server.

To avoid such a big increase on the timeouts, I propose to run the speedtest-cli in a seperate container and have the output shared withthe Zabbix agent. This way, Ißm still using a UserParameter but this time only to get the content of the last run into a text parameter which then gets split into the relevant properties to be monitored.

# What is Zabbix?
Zabbix is an enterprise-class open source distributed monitoring solution that monitors numerous parameters of a network and the health and integrity of servers.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com

# What is speedtest-cli?
Command line interface for testing internet bandwidth using speedtest.net

For more information and related downloads for speedtest-cli components, please visit https://github.com/sivel/speedtest-cli

# How to use this image

## Build container

If the version on DockerHub is not suitable or outdated, get the sources from this repository and apply changes as needed. Finally build the image.

```console
$ sudo docker build --tag speedtest-cron:1.1 .
```

## Download docker images

More convenient is to get it from DockerHub

## Start `speedtest-cron`

Start a speedtest-cron container as follows:

```console
$ sudo docker container run -it --rm --name speedtest-cron \
  -v /volume1/docker/speedtest/data:/data/speedtest:rw \
  -e STC_INTERVAL="10" \
  -e STC_FORMAT="json" \
  -e STC_FILE_NAME="speedtest.json" \
tomychr/speedtest-cron:latest
```
To be finished

