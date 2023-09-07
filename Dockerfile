FROM ubuntu:20.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean

RUN apt-get --yes install \
  curl \
  ghostscript \
  graphicsmagick \
  lftp \
  netpbm \
  ocrmypdf \
  sane \
  sane-utils \
  ssh \
  sshpass \
  wget \
  x11-common && \
  apt-get -y clean

RUN cd /tmp && \
	wget https://download.brother.com/welcome/dlf105200/brscan4-0.4.11-1.amd64.deb && \
	dpkg -i /tmp/brscan4-0.4.11-1.amd64.deb && \
	rm /tmp/brscan4-0.4.11-1.amd64.deb

RUN cd /tmp && \
	wget https://download.brother.com/welcome/dlf006652/brscan-skey-0.3.1-2.amd64.deb && \
	dpkg -i /tmp/brscan-skey-0.3.1-2.amd64.deb && \
	rm /tmp/brscan-skey-0.3.1-2.amd64.deb

ADD cmd.sh /opt/brother/cmd.sh

ADD script /opt/brother/scanner/brscan-skey/script/

ENV NAME="Scanner"
ENV MODEL="MFC-L2700DW"
ENV IPADDRESS="192.168.1.123"
ENV USERNAME="NAS"

#only set these variables, if inotify needs to be triggered (e.g., for CloudStation):
ENV SSH_USER=""
ENV SSH_PASSWORD=""
ENV SSH_HOST=""
ENV SSH_PATH=""

#only set these variables, if you need FTP upload:
ENV FTP_USER=""
ENV FTP_PASSWORD=""
ENV FTP_HOST=""
# Make sure this ends in a slash.
ENV FTP_PATH="/scans/" 

EXPOSE 54925
EXPOSE 54921

#directory for scans:
VOLUME /scans
RUN mkdir --parents /scans

CMD /opt/brother/cmd.sh
