FROM --platform=${TARGETPLATFORM:-linux/arm64} debian:bullseye

ARG RELEASE=stable

RUN apt update && apt install -y curl wget sudo locales lsb-release libglib2.0-0
RUN wget -qO- https://dl.hoobs.org/${RELEASE} | sudo bash -
RUN sudo apt install -y hoobsd hoobs-cli hoobs-gui
RUN sudo apt clean && sudo rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/hoobs
WORKDIR /var/lib/hoobs
EXPOSE 80/tcp

ENTRYPOINT ["/bin/bash", "-c", "sudo hbs --verbose --debug install -p 80; sudo hoobsd hub"]
