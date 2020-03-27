FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y libmicrohttpd-dev libjansson-dev \
	libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
	libconfig-dev pkg-config gengetopt libtool automake git wget doxygen graphviz \
    libavutil-dev libavcodec-dev libavformat-dev nginx gtk-doc-tools libnice-dev

# RUN git clone https://gitlab.freedesktop.org/libnice/libnice
# RUN cd libnice && \
#     ./autogen.sh --prefix=/usr && \
#     cd ..
# RUN cd libnice && ./configure --prefix=/usr && \
#     make -j10 && make install

RUN wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar xfv v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make -j10 shared_library && make install

COPY . .

RUN sh autogen.sh
RUN ./configure \
    --enable-post-processing \
    --disable-websockets \
    --disable-data-channels \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-unix-sockets \
    --enable-plugin-echotest \
    --enable-plugin-videocall \
    --enable-plugin-videoroom \
    --enable-all-handlers
RUN make -j12
RUN make install
RUN make configs && ldconfig
# RUN cp -R cert /etc/mycerts
# COPY nginx.conf /etc/nginx/nginx.conf

# CMD nginx && janus
CMD janus