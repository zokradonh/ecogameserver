FROM xueshanf/awscli

RUN apk add --no-cache tini && \
    mkdir -p /versionwatch/state

COPY crontab.tmp check_and_trigger.sh /versionwatch/

RUN crontab /versionwatch/crontab.tmp && \
    chmod a+x /versionwatch/check_and_trigger.sh

# cache last state
VOLUME /versionwatch/state

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/crond", "-f", "-d", "8"]