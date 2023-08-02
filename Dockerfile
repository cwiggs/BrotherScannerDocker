FROM ubuntu:18.04

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
  x11-common- && \
  apt-get -y clean

RUN cd /tmp && \
	wget https://download.brother.com/welcome/dlf105200/brscan4-0.4.11-1.amd64.deb && \
	dpkg -i /tmp/brscan4-0.4.11-1.amd64.deb && \
	rm /tmp/brscan4-0.4.11-1.amd64.deb

RUN cd /tmp && \
	wget https://download.brother.com/welcome/dlf006652/brscan-skey-0.3.1-2.amd64.deb && \
	dpkg -i /tmp/brscan-skey-0.3.1-2.amd64.deb && \
	rm /tmp/brscan-skey-0.3.1-2.amd64.deb

ADD files/runScanner.sh /opt/brother/runScanner.sh

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

#directory for config files:
VOLUME /opt/brother/scanner/brscan-skey

CMD /opt/brother/runScanner.sh

