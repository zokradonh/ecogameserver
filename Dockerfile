FROM xueshanf/awscli AS awshelper

RUN latestFilename=$( aws --no-sign-request s3 ls eco-releases | grep -E -e EcoServer_v[0-9.]*-beta.zip | sort -n | tail -1 | awk '{print $4}' ) && \
    echo $latestFilename | sed 's/EcoServer_v\([0-9.]*-beta\).zip/\1/' > /VERSION && \
    aws --no-sign-request s3 cp s3://eco-releases/$latestFilename /EcoServer.zip

FROM mono

LABEL maintainer=az@zok.xyz \
      version="1.2"

RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/cache/apt /var/lib/apt/lists

# get downloaded server archive
COPY --from=awshelper /EcoServer.zip /EcoServer.zip
COPY --from=awshelper /VERSION /app/VERSION

# unzip and save default config files
RUN mkdir -p /app/ /app/DefaultConfigs && \
    unzip -q /EcoServer.zip -d /app/ && \
    rm /EcoServer.zip && \
    cp /app/Configs/* /app/DefaultConfigs/

EXPOSE 3000/udp 3001/tcp

COPY start.sh generate_config.sh /app/

RUN chmod +x /app/start.sh /app/generate_config.sh

CMD ["/app/start.sh"]