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
    apt-get autoclean ; \
    apt-get clean ; \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN RELEASE=3.8.1 ; \
    wget https://github.com/cdr/code-server/releases/download/v"$RELEASE"/code-server-"$RELEASE"-linux-amd64.tar.gz ; \
    tar -xzvf code-server-"$RELEASE"-linux-amd64.tar.gz ; \
    cp -r code-server-"$RELEASE"-linux-amd64 /usr/lib/code-server ; \
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server

# Expose Port and execute IDE
EXPOSE 8080

CMD /usr/bin/code-server --bind-addr 0.0.0.0:8080 --user-data-dir /workspace --auth password
