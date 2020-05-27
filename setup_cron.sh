#! /bin/bash
# setup a cron schedule

echo "** Using '$STC_FORMAT' for output format"
if [ "$STC_FORMAT" == "json" ]; then
    echo "*/$STC_INTERVAL * * * * python /usr/local/bin/speedtest-cli --$STC_FORMAT >/data/speedtest/$STC_FILE_NAME
# This extra line makes it a valid cron" > crontab.txt
else
    if [ "$STC_FORMAT" == "csv" ]; then
        echo "*/$STC_INTERVAL * * * * python /usr/local/bin/speedtest-cli --$STC_FORMAT >/data/speedtest/$STC_FILE_NAME
# This extra line makes it a valid cron" > crontab.txt
    else
        echo "[Error] Unsupported 'STC_FORMAT' '$STC_FORMAT' for output format. Has to be either 'json' or 'csv'"
    fi
fi

# run cron in foreground
echo "** going to run supercronic"
supercronic ./crontab.txt
