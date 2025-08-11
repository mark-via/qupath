FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS build

LABEL maintainer="mark@viascientific.com"

RUN sed -i 's/http:\/\//https:\/\//g' /etc/apt/sources.list.d/*

RUN apt-get update -y -o Acquire::https::Verify-Peer=false && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o Acquire::https::Verify-Peer=false  \
         ca-certificates \
         wget \
         unzip \
         dos2unix
RUN apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         libgl1 \
         xz-utils \
         nano \
         qt5dxcb-plugin \
         openjfx && \
     rm -rf /var/lib/apt/lists/*
  
RUN mkdir -p /opt/qupath && \
    chmod 777 /opt/qupath && \
    cd /opt/qupath/ && \
    wget https://github.com/qupath/qupath/releases/download/v0.6.0/QuPath-v0.6.0-Linux.tar.xz && \
    tar -xvf QuPath-v0.6.0-Linux.tar.xz && \
    rm /opt/qupath/QuPath-v0.6.0-Linux.tar.xz -rf && \
    chmod u+x /opt/qupath/QuPath/bin/QuPath

RUN cat >/startapp.sh <<'EOF' && \
    chmod +x /startapp.sh && \
    dos2unix /startapp.sh
#!/bin/sh -f

# The IMAGE_PATH variable is important as the Galaxy IT is inserting the user-chosen file into this path.

HOME="/tmp"
_JAVA_OPTIONS="-Duser.home=${HOME} -Djavafx.cachedir=/tmp" exec /opt/qupath/QuPath/bin/QuPath --image "${IMAGE_PATH}" --quiet
EOF

ENV APP_NAME="QuPath"

ENV KEEP_APP_RUNNING=0

ENV TAKE_CONFIG_OWNERSHIP=1

WORKDIR /config

# Expose GUI and VNC ports used by the baseimage
EXPOSE 5800 5900