#######################################################################
#
#  这个Docker file根据CoolCantonese项目里所有相关的docker file拼起来而形成的
#
#######################################################################

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

# my simulation of VOLUME
RUN \
  mkdir /Cantonese && \
  mkdir /Cantonese_audio

#######################################################################

#copy codes
COPY ./ /Cantonese

EXPOSE 80

ENTRYPOINT ["python"]
CMD ["wechat.py", "-e", "Pro"]

#######################################################################
# 根据原始输出已经无法运行，毕竟有些步骤并没有。于是自己写了如下起始命令

#EXPOSE 80
#ENTRYPOINT []
#CMD []

# 将其程序代码拷贝到docker目录，然后还是使用其原始工作方式。