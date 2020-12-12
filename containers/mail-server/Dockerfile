FROM marooou/postfix-roundcube 
COPY ./main.cf /etc/postfix/main.cf
RUN echo "export TERM=xterm" >> tee /etc/skel/.bashrc
ENTRYPOINT ["/sbin/init"]

