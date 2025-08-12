FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS build

MAINTAINER mark@viascientific.com


RUN sed -i 's/http:\/\//https:\/\//g' /etc/apt/sources.list.d/*

RUN apt-get update -y -o Acquire::https::Verify-Peer=false && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  -o Acquire::https::Verify-Peer=false  \
         ca-certificates \
         wget
RUN apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         libgl1 \
         xz-utils \
         openjfx \
         nano \
         qt5dxcb-plugin && \
     rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/qupath && \
    chmod 777 /opt/qupath && \
    cd /opt/qupath/ && \
    wget https://github.com/qupath/qupath/releases/download/v0.6.0/QuPath-v0.6.0-Linux.tar.xz && \
    tar -xvf QuPath-v0.6.0-Linux.tar.xz && \
    rm -f /opt/qupath/QuPath-v0.6.0-Linux.tar.xz && \
    chmod u+x /opt/qupath/QuPath/bin/QuPath

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Set the name of the application.
ENV APP_NAME="QuPath"

ENV KEEP_APP_RUNNING=0

ENV TAKE_CONFIG_OWNERSHIP=1

WORKDIR /config