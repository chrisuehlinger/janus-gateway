FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y libmicrohttpd-dev libjansson-dev \
        libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
        libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
        libconfig-dev pkg-config gengetopt libtool automake git wget doxygen graphviz \
        libavutil-dev libavcodec-dev libavformat-dev nginx gtk-doc-tools && \
    git clone https://gitlab.freedesktop.org/libnice/libnice && \
    cd libnice && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar xfv v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make -j$(nproc) shared_library && \
    make install

WORKDIR /usr/src/janus

COPY . .
RUN sh autogen.sh && ./configure \
    --enable-post-processing \
    --disable-websockets \
    --disable-data-channels \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
    --enable-plugin-echotest \
    --enable-plugin-videocall \
    --enable-plugin-videoroom \
    --enable-all-handlers && \
    make -j$(nproc) && \
    make install && \
    make configs && \
    ldconfig
COPY nginx.conf /etc/nginx/nginx.conf

CMD nginx && janus
# CMD janus