#Start dockerfile by creating all the dependencies needed.
FROM debian:stable AS owntonedepend
LABEL maintainer="Matt Dickinson <matt@sanbridge.org>" 
 
#Installation of all of the dependencies needed to build Music Player Daemon from source. 

RUN apt-get update && apt-get install -y \
	avahi-daemon \
	build-essential \
	git \
	autotools-dev \
	autoconf \
	automake \
	libtool \
	gettext \
	gawk \
	gperf \
	bison \
	flex \
	libconfuse-dev \
	libunistring-dev \
	libsqlite3-dev \
	libavcodec-dev \
	libavformat-dev \
	libavfilter-dev \
	libswscale-dev \
	libavutil-dev \
	libasound2-dev \
	libmxml-dev \
	libgcrypt20-dev \
	libavahi-client-dev \
	zlib1g-dev \
	libevent-dev \
	libplist-dev \
	libsodium-dev \
	libjson-c-dev \
	libwebsockets-dev \
	libcurl4-openssl-dev \
	libprotobuf-c-dev \
	npm

FROM node as webui 
WORKDIR /usr/src/app


#Setting a new stage for the dockerfile so that the cache can be utilized and the build can be sped up.
FROM owntonedepend AS owntonebuild

#Set the working directory of the dockerfile at this stage.
ENV HOME /root

RUN git clone https://github.com/owntone/owntone-server.git

#Change the working directory to MPD for installation.
WORKDIR owntone-server

RUN autoreconf -i 
RUN ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-install-user --disable-install-systemd

#RUN ./configure --disable-install-systemd
RUN make
RUN make install

WORKDIR web-src

RUN npm install

# install dependencies
#npm install

# Serve with hot reload at localhost:3000
# (assumes that OwnTone server is running on localhost:3689)
RUN npm run serve

# Serve with hot reload at localhost:3000
# (with remote OwnTone server reachable under owntone.local:3689)
RUN VITE_OWNTONE_URL=http://owntone.local:3689 npm run serve

# Build for production with minification (will update web interface
# in "../htdocs")
RUN npm run build

# Format code
RUN npm run format

# Lint code (and fix errors that can be automatically fixed)
RUN npm run lint

WORKDIR /

RUN mkdir -p /usr/local/var/run
RUN mkdir -p /usr/local/var/log # or change logfile in conf
#USER unkown
#RUN chown unknown /usr/local/var/cache/owntone # or change conf
COPY owntone.conf /etc
ENTRYPOINT owntone
#CMD owntone
WORKDIR /
EXPOSE 6600 3688 3689
