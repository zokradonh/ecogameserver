FROM xueshanf/awscli AS awshelper

RUN latestFilename=$( aws --no-sign-request --endpoint-url https://s3-us-west-2.amazonaws.com/ s3 ls eco-releases | grep -E -e EcoServer_v[0-9.]*-beta.zip | sort -n | tail -1 | awk '{print $4}' ) && \
    aws --no-sign-request --endpoint-url https://s3-us-west-2.amazonaws.com/ s3 cp s3://eco-releases/$latestFilename /EcoServer.zip

FROM mono

LABEL maintainer=az@zok.xyz \
      version="1.0"

# we also need jq for editing config files via environment variables in bootstrap
RUN apt-get update && \
    apt-get install -y unzip jq && \
    rm -rf /var/cache/apt /var/lib/apt/lists

# get downloaded server archive. yes, copy to root dir to save a build layer
COPY --from=awshelper /EcoServer.zip /EcoServer.zip

# unzip and save default configs files
RUN mkdir -p /app/ /app/DefaultConfigs && \
    unzip -q /EcoServer.zip -d /app/ && \
    rm /EcoServer.zip && \
    cp /app/Configs/* /app/DefaultConfigs/

EXPOSE 2999/udp 3000 3001

COPY bootstrap.sh generate_config.sh /app/

RUN chmod +x /app/bootstrap.sh /app/generate_config.sh

CMD ["/app/bootstrap.sh"]

