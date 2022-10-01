#Start dockerfile by creating all the dependencies needed.
FROM debian:stable AS depend
LABEL maintainer="Matt Dickinson <matt@sanbridge.org>" 
 
#Installation of all of the dependencies needed to build Music Player Daemon from source. 
RUN apt-get update && apt-get install -y \
#RUN apt-get update && apt-get -y install --no-install-recommends \
	curl \
	git \
	autoconf \
	automake \
	libtool \ 
	gettext \ 
	gperf \ 
	bison \
	flex \ 
	avahi-daemon \ 
	sqlite3 \
	ffmpeg \ 
	libconfuse \ 
	libevent \
	MiniXML \ 
	gcrypt \
	zlib \ 
	libunistring \
	libjson-c \
	libcurl \ 
	libplist \ 
	libsodium \ 
	libprotobuf-c \ 
	libasound \ 
	libgnutls \ 
	libwebsockets

#Setting a new stage for the dockerfile so that the cache can be utilized and the build can be sped up.
FROM depend AS mpdbuild

#Set the working directory of the dockerfile at this stage.
ENV HOME /root

RUN git clone https://github.com/owntone/owntone-server.git

#Change the working directory to MPD for installation.
WORKDIR owntone-server

RUN autoreconf -i 
RUN ./configure
RUN make
RUN make install

RUN mkdir -p /usr/local/var/run
RUN mkdir -p /usr/local/var/log # or change logfile in conf
RUN chown unknown /usr/local/var/cache/owntone # or change conf

