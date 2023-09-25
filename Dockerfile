FROM --platform=${TARGETPLATFORM:-linux/arm64} debian

RUN apt update && apt install -y wget curl lsb-release sudo
RUN wget -qO- https://dl.hoobs.org/stable | sudo bash -
RUN apt install -y hoobsd hoobs-cli hoobs-gui && apt-get clean
RUN sudo mkdir -p /hoobs && \
    sudo rm -rf /var/lib/hoobs && \
    sudo ln -s /hoobs /var/lib/hoobs
RUN sudo hbs --verbose --debug install -p 80

VOLUME /hoobs
WORKDIR /hoobs
EXPOSE 80/tcp

ENTRYPOINT ["sudo", "/bin/bash", "-c", "sudo hbs install -p 80; sudo hoobsd hub"]
