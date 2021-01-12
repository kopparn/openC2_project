FROM mysql
RUN apt-get update
RUN apt-get install -y iproute2 iputils-ping apache2 php libapache2-mod-php php-cli php-mysql vim python3 python3-pip
RUN pip3 install stix2
RUN service apache2 restart
COPY ./containers/mysql-server/web-server/index.html /var/www/html/index.html
COPY ./containers/mysql-server/web-server/action.php /var/www/html/action.php
COPY ./containers/mysql-server/web-server/openc2.php /var/www/html/openc2.php
COPY ./containers/mysql-server/my.cnf /etc/mysql/my.cnf
COPY ./containers/mysql-server/my_database.sql /tmp/my_database.sql
RUN mkdir /etc/openc2-proxy
COPY ./src/mysql-proxy /etc/openc2-proxy/mysql-proxy 
COPY ./src/openc2 /etc/openc2-proxy/openc2
COPY ./src/test.py /etc/openc2-proxy/test.py
RUN mkdir /var/www/backups
RUN chown -R www-data /var/www/backups
