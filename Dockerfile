# spedtest-cli in a docker container with cron
FROM python:3-alpine

LABEL org.opencontainers.image.title="speedtest-cron" \
      org.opencontainers.image.authors="Thomas Christen <thomas.christen@active.ch>" \
      org.opencontainers.image.vendor="" \
      org.opencontainers.image.url="" \
      org.opencontainers.image.description="spedtest-cli in a docker container with cron" \
      org.opencontainers.image.licenses="GPL v2.0"

STOPSIGNAL SIGTERM

# Define a new group and add a new user
RUN addgroup -S grp_speedtest && adduser -H -D -S usr_speedtest -G grp_speedtest

#Set the current directory
WORKDIR /usr/src/app

# Install core components
RUN pip install speedtest-cli \
    && apk update \
    && apk add bash \
    && apk add curl \
    && rm -rf /var/lib/apt/lists/*

# Install supercronic - a replacement of crond
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-386 \
    SUPERCRONIC=supercronic-linux-386 \
    SUPERCRONIC_SHA1SUM=e0126b0102b9f388ecd55714358e3ad60d0cebdb

RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# COPY ./crontab /etc/crontab
COPY setup_cron.sh .
RUN chmod +x setup_cron.sh

# Define default environment varaiables
ENV STC_INTERVAL="10"
ENV STC_FORMAT="json"
ENV STC_FILE_NAME="speedtest.json"

# Define volume for output
VOLUME [ "/data/speedtest" ]

# ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/docker-entrypoint.sh"]

# Change from root to normal user
USER usr_speedtest

# 
CMD [ "/usr/src/app/setup_cron.sh" ]

# CMD ["/usr/sbin/zabbix_agentd", "--foreground", "-c", "/etc/zabbix/zabbix_agentd.conf"]
