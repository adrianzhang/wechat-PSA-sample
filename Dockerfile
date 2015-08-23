FROM ubuntu:14.04
MAINTAINER Adrian Zhang "adrian@favap.com"
ENV REFRESHED_AT 2015-8-23

#######################################################################

#COPY ekho-6.0/ /ekho-6.0

RUN \
  buildDeps='build-essential  wget' && \
  buildLibDeps='libsndfile1-dev libpulse-dev libvorbis-dev libmp3lame-dev' && \
  set -x && \
  apt-get update && \
  apt-get install -y $buildDeps && \
  apt-get install -y $buildLibDeps && \
  wget http://iweb.dl.sourceforge.net/project/e-guidedog/Ekho/6.0/ekho-6.0.tar.xz && \
  tar xvf ekho-6.0.tar.xz && \
  cd ekho-6.0 && \
  ./configure --with-mp3lame && \
  make install && \
  ekho -t mp3 -o test.mp3 hello && \
  cd .. && \
  rm ekho-6.0.tar.xz && \
  rm -rf ekho-6.0 && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get purge -y --auto-remove $buildDeps

#######################################################################

## Install ffmpeg and python and python-lxml.
RUN \
  InstallDeps='software-properties-common' && \
  set -x && \
  apt-get update && \
  apt-get install -y $InstallDeps && \
  add-apt-repository ppa:mc3man/trusty-media  && \
  apt-get update && \
  apt-get -y install ffmpeg && \
  apt-get purge -y --auto-remove $InstallDeps && \
  apt-get install -y python python-dev python-pip python-lxml && \
  rm -rf /var/lib/apt/lists/*

## Install Python packages.
COPY requirements.txt /tmp/requirements.txt
WORKDIR /tmp
RUN pip install -r requirements.txt && rm -rf requirements.txt

#######################################################################

#VOLUME ["/Cantonese","/Cantonese_audio"]
#WORKDIR /Cantonese
#EXPOSE 80
#ENTRYPOINT []
#CMD [/usr/bin/sh]

#copy codes
#COPY ./ /Cantonese

EXPOSE 80

#ENTRYPOINT ["python"]
#CMD ["wechat.py", "-e", "Pro"]