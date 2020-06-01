# spedtest-cli in a docker container with cron
FROM python:3-alpine

LABEL maintainer="thomas.christen@active.ch"

# args for building the container
ARG BUILD_DATE
ARG BUILD_VERSION
ARG VSC_REF


LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="tomychr/speedtest-cron" \
      org.label-schema.description="spedtest-cli in a docker container with cron" \
      org.label-schema.vsc-url="https://github.com/tomyChr/speedtest-cron" \
      org.label-schema.vsc-ref=$VSC_REF \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.docker.cmd="docker container run -it --name speedtest-cron -v /volume1/docker/speedtest/data:/data/speedtest:rw -e STC_INTERVAL="10" -e STC_FORMAT="json" -e STC_FILE_NAME="speedtest.json" tomychr/speedtest-cron:latest"

STOPSIGNAL SIGTERM

# Set the current directory
WORKDIR /usr/src/app

# Define a new group and add a new user
RUN addgroup -S grp_speedtest \
    && adduser -H -D -S usr_speedtest -G grp_speedtest \
    && chown -R usr_speedtest:grp_speedtest /usr/src/app

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
