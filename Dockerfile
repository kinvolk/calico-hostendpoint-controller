# TODO: use more lockdown image in the future?
FROM debian:9

# TODO: Make sure coreutils is installed, and all packages needed for commands
# used in the script

WORKDIR /app

ARG ARCH
# FIXME: docker can't use the cache for HTTP resources it seems, so the build is
# long. I usually use a local copy and modify the dockerfile, but a better way
# should be used?
ADD https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/$ARCH/kubectl /usr/local/bin

ADD run worker-host-endpoint.yaml.tmpl /app/
ADD run vpn-host-endpoint.yaml.tmpl /app/

RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /app/run
CMD [ "/app/run" ]
