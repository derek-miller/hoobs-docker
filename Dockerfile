FROM --platform=${TARGETPLATFORM:-linux/arm64} ubuntu:22.04

RUN apt update && apt install -y wget curl lsb-release sudo
RUN wget -qO- https://dl.hoobs.org/stable | sudo bash -
RUN apt install -y hoobsd hoobs-cli hoobs-gui
RUN apt install -y bluetooth wpasupplicant network-manager avahi-daemon avahi-utils dnsmasq
RUN apt-get clean
RUN sudo mkdir -p /hoobs && \
    sudo rm -rf /var/lib/hoobs && \
    sudo ln -s /hoobs /var/lib/hoobs
RUN sudo hbs --verbose --debug install -p 80
RUN adduser --gecos hoobs --disabled-password hoobs
RUN echo "hoobs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN adduser hoobs sudo
RUN echo "hoobs:hoobsadmin" | chpasswd
RUN passwd -l root
RUN echo "hoobs" > /etc/hostname
RUN sudo rm -rf /var/lib/apt/lists/*

VOLUME /hoobs
WORKDIR /hoobs
EXPOSE 80/tcp

ENTRYPOINT ["/bin/bash", "-c", "sudo hbs install -p 80; hoobsd hub"]
