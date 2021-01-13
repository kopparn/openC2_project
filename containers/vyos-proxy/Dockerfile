FROM debian
RUN apt-get update
RUN apt-get install -y init iproute2 iputils-ping apache2 php libapache2-mod-php php-cli vim python3 python3-pip openssh-client
RUN pip3 install stix2
RUN service apache2 restart
COPY ./containers/mysql-server/web-server/openc2.php /var/www/html/openc2.php
RUN mkdir /etc/openc2-proxy
COPY ./src/vyos-proxy /etc/openc2-proxy/src
COPY ./src/openc2 /etc/openc2-proxy/openc2
ENTRYPOINT /sbin/init
