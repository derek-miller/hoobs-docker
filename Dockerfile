FROM debian

ARG PORT=80
VOLUME /hoobs

RUN apt update && apt install -y wget curl lsb-release sudo
RUN wget -qO- https://dl.hoobs.org/stable | sudo bash -
RUN sudo apt install -y hoobsd hoobs-cli hoobs-gui
RUN sudo mkdir -p /hoobs && \
    sudo rm -rf /var/lib/hoobs && \
    sudo ln -s /hoobs /var/lib/hoobs
RUN sudo hbs --verbose --debug install -p "${PORT}"

EXPOSE $PORT

CMD ["/usr/bin/hoobsd", "hub"]

