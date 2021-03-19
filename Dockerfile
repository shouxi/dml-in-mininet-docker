FROM willzhoupan/naad-gpu:v4.0


USER root
WORKDIR /root

COPY  docker-entry-point.sh /docker-entry-point.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    openvswitch-switch \
    curl \
    iproute2 \
    iputils-ping \
    mininet \
    net-tools \
    tcpdump \
    vim \
    sudo \
    tmux \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /docker-entry-point.sh \
 && pip3 install -U --no-cache posix_ipc

#CMD ["bin/bash"]

EXPOSE 6633 6653 6640

ENTRYPOINT [ "/docker-entry-point.sh" ]