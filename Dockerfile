FROM nvidia/cuda:10.2-devel-ubuntu18.04

ENV CUDNN_VERSION 7.6.5.32

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
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /docker-entry-point.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.2 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.2 && \
    apt-mark hold libcudnn7 \
    && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    ca-certificates \
    libjpeg-dev \
    libpng-dev \
    net-tools \
    iputils-ping \
    vim\
    openssh-server \
    python3-dev \
    python3-pip \
    python3-setuptools \
    && apt-get clean \
    && apt-get autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U --no-cache \
    tqdm \
    wheel \
    numpy \
    scipy \
    pyyaml \
    && pip3 install Pillow==6.2.2 \
    && pip3 install torch torchvision
    #&& mkdir /var/run/sshd \
    #&& echo 'root:singa' | chpasswd \
    #&& sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    #&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    #&& mkdir /root/.ssh \
    
#COPY . /daml 

#CMD ["bin/bash"]

EXPOSE 6633 6653 6640

ENTRYPOINT [ "/docker-entry-point.sh" ]