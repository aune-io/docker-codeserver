FROM ubuntu:latest

# Update OS
RUN export DEBIAN_FRONTEND=noninteractive ; \
    ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime ; \
    apt-get update ; \
    apt-get -y dist-upgrade ; \
    apt-get -y autoremove ; \
    apt-get autoclean ; \
    apt-get clean ; \
    apt-get -y install sudo nano htop curl wget unzip git git-flow nodejs npm mysql-client ; \
    apt-get -y install software-properties-common ; \
    add-apt-repository ppa:ondrej/php ; \
    apt-get -y install php8.2 php8.2-mysql php8.2-mbstring php8.2-curl php8.2-xml php8.2-bcmath php8.2-gd php8.2-intl php8.2-soap php8.2-zip php8.2-cli libapache2-mod-php8.2 ; \
    apt-get autoclean ; \
    apt-get clean ; \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN a2enmod headers rewrite

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ; \
    php composer-setup.php ; \
    php -r "unlink('composer-setup.php');" ; \
    mv composer.phar /usr/local/bin/composer

# Install Code Server
#RUN set -e -x ; \
#    RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
#    | awk '/tag_name/{print $4;exit}' FS='[""]' \
#    | sed "s/v//") ; \
RUN RELEASE=3.8.1 ; \
    wget https://github.com/cdr/code-server/releases/download/v"$RELEASE"/code-server-"$RELEASE"-linux-amd64.tar.gz ; \
    tar -xzvf code-server-"$RELEASE"-linux-amd64.tar.gz ; \
    cp -r code-server-"$RELEASE"-linux-amd64 /usr/lib/code-server ; \
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server

# Expose Port and execute IDE
EXPOSE 8080

CMD /usr/bin/code-server --bind-addr 0.0.0.0:8080 --user-data-dir /workspace --auth password
