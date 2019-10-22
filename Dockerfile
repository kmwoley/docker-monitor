FROM debian:stable-slim
LABEL Maintainer="Kevin Woley <https://github.com/kmwoley>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        bluetooth \
        bluez \
        bluez-hcidump \
        bc \
        usbutils \
        git \
        curl \
        ca-certificates \
        mosquitto \
        mosquitto-clients \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/andrewjfreyer/monitor.git /monitor

RUN mkdir /config

VOLUME /config

COPY ./config/* /config/
COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]

WORKDIR /monitor

CMD ["/bin/bash", "monitor.sh", "-D", "/config"]
