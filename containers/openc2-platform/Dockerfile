FROM debian
RUN apt-get update
RUN apt-get install -y init iproute2 iputils-ping vim python3 python3-pip
RUN pip3 install stix2
RUN mkdir /etc/openc2-platform
COPY ./src/openc2 /etc/openc2-platform/openc2
COPY ./src/openc2-platform /etc/openc2-platform/src
ENTRYPOINT /sbin/init
