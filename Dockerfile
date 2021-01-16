FROM ubuntu:focal

RUN apt-get update
# To avoid timezone selection
RUN apt-get install -y tzdata

# basic build tools
RUN apt-get install -y \
        git wget \
        pkg-config gengetopt libtool automake make \
        meson ninja-build

# Required libraries
RUN apt-get install -y \
        libmicrohttpd-dev libjansson-dev \
        libssl-dev  libsofia-sip-ua-dev libglib2.0-dev \
        libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
        libconfig-dev

# gstreamer
RUN apt-get install -y \
        libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav \
        gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa \
        gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio

# libnice
RUN cd ~ && \
        git clone https://gitlab.freedesktop.org/libnice/libnice && \
        cd libnice && \
        meson --prefix=/usr --libdir=lib build && \
        ninja -C build && \
        ninja -C build install

# libstrp
RUN cd ~ && \
        wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz && \
        tar xfv v2.3.0.tar.gz && \
        cd libsrtp-2.3.0 && \
        ./configure --prefix=/usr --enable-openssl && \
        make shared_library && make install

# janus
RUN cd ~ && \
        git clone https://github.com/meetecho/janus-gateway.git

RUN cd ~/janus-gateway && \
        ./autogen.sh && \
        ./configure --prefix=/opt/janus && \
        make && \
        make install

RUN cd ~/janus-gateway && \
        make configs
COPY janus.transport.http.jcfg /opt/janus/etc/janus/janus.transport.http.jcfg

# nginx
RUN apt-get install -y nginx
RUN cd ~/janus-gateway && \
        cp -a html/* /var/www/html

# Enable HTTPS on Janus
COPY nginx-default /etc/nginx/sites-available/default

# Making self-signed certificate
RUN apt-get install ssl-cert
RUN make-ssl-cert generate-default-snakeoil

# Run nginx and janus
COPY run-services.sh run-services.sh
CMD ./run-services.sh
