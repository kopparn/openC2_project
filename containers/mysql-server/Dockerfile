FROM mysql
RUN apt-get update
RUN apt-get install -y iproute2 apache2 php libapache2-mod-php php-cli php-mysql vim
RUN service apache2 restart
COPY ./index.html /var/www/html/index.html
COPY ./action.php /var/www/html/action.php
COPY ./my.cnf /etc/mysql/my.cnf
COPY ./my_database.sql /tmp/my_database.sql
