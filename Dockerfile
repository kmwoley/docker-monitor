FROM debian:stable-slim
LABEL Maintainer="Kevin Woley <https://github.com/kmwoley>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        bc \        
        bluetooth \
        bluez \
        bluez-hcidump \
        ca-certificates \
        curl \
        git \
        mosquitto \
        mosquitto-clients \
        procps \
        usbutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/andrewjfreyer/monitor.git /monitor

RUN cd /monitor \
    # Docker images don't have systemctl - this is a hack to supress errors
    && sed -i 's|systemctl is-active.*|SERVICE_ACTIVE=false|' support/init \
    && sed -i 's|systemctl|#systemctl|' monitor.sh
    
RUN mkdir /config

VOLUME /config

COPY ./config/* /config/
COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]

WORKDIR /monitor

CMD ["/bin/bash", "monitor.sh", "-D", "/config"]
