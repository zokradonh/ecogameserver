ARG BUILD_VERSION=custom
ARG MONO_VERSION=6.0

FROM xueshanf/awscli AS awshelper
ARG BUILD_VERSION
RUN \
    if [[ -z "$BUILD_VERSION" || "$BUILD_VERSION" == "custom" ]]; \
    then \
        latestFilename=$( aws --no-sign-request s3 ls eco-releases | grep -E -e "EcoServer_v[0-9.]*-beta.zip" | sort -n | tail -1 | awk '{print $4}' ); \
    else \
        latestFilename="EcoServer_v$BUILD_VERSION.zip"; \
    fi && \
    echo "$latestFilename" | sed 's/EcoServer_v\([0-9.]*-beta\).zip/\1/' > /VERSION && \
    aws --no-sign-request s3 cp "s3://eco-releases/$latestFilename" /ecoserver.zip && \
    mkdir /eco && \
    unzip -q -d /eco /ecoserver.zip

FROM mono:$MONO_VERSION

# copy downloaded server software
COPY --from=awshelper /eco /app
COPY --from=awshelper /VERSION /app/VERSION

# preserve default config files
RUN mkdir -p /app/DefaultConfigs && \
    cp /app/Configs/* /app/DefaultConfigs/

EXPOSE 3000/udp 3001/tcp

COPY start.sh generate_config.sh README.md /app/

CMD ["/app/start.sh"]

# Metadata
ARG BUILD_VERSION
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.version="$BUILD_VERSION" \
      org.label-schema.vendor=ZokRadonh \
      org.label-schema.license=MIT \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.description="ECO game server" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/zokradonh/ecogameserver" \
      org.label-schema.docker.cmd="docker run -d -p 3000:3000/udp -p 3001:3001/tcp -v eco_config:/app/Configs -v eco_world:/app/Storage zokradonh/ecogameserver" \
      org.label-schema.usage="/app/README.md"
