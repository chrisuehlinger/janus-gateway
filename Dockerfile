FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates libmicrohttpd-dev libjansson-dev \
        libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
        libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
        libconfig-dev pkg-config gengetopt libtool automake git wget doxygen graphviz \
        libavutil-dev libavcodec-dev libavformat-dev nginx gtk-doc-tools cmake \
        python3 python3-pip python3-setuptools python3-wheel ninja-build && \
    pip3 install meson && \
    git clone https://gitlab.freedesktop.org/libnice/libnice && \
    cd libnice && \
    meson --prefix=/usr build && \
    ninja -C build && \
    ninja -C build install && \
    cd .. && \
    rm -fdr libnice
RUN wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar xfv v2.2.0.tar.gz && \
    rm v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make -j$(nproc) shared_library && \
    make install && \
    cd .. && \
    rm -fdr libsrtp-2.2.0 && \
    git clone https://libwebsockets.org/repo/libwebsockets && \
    cd libwebsockets && \
    git checkout v3.2-stable && \
    mkdir build && \
    cd build && \
    cmake -DLWS_MAX_SMP=1 -DLWS_IPV6=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
    make -j$(nproc) && make install && \
    cd ../.. && \
    rm -fdr libwebsockets && \
    git clone https://github.com/sctplab/usrsctp && \
    cd usrsctp && \
    ./bootstrap && \
    ./configure --prefix=/usr && \
    make -j$(nproc) && make install &&\
    cd .. && \
    rm -fdr usrsctp && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/janus

COPY . .
RUN sh autogen.sh
RUN ./configure \
    --enable-post-processing \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
    --enable-plugin-echotest \
    --enable-plugin-videocall \
    --enable-plugin-videoroom \
    --enable-plugin-audiobridge \
    --enable-all-handlers && \
    make -j$(nproc) && \
    make install && \
    ldconfig

CMD ["/opt/janus/bin/janus", "--configs-folder=/etc/janus"]