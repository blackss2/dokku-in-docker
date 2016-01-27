FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y git make curl software-properties-common sudo wget man openssh-server
RUN apt-get install -y iptables ca-certificates lxc
RUN git clone https://github.com/progrium/dokku /root/dokku
RUN cd /root/dokku; make sshcommand
RUN cd /root/dokku; make help2man
RUN cd /root/dokku; make version
RUN cd /root/dokku; make plugn
RUN cd /root/dokku; make copyfiles
RUN cd /root/dokku; make plugin-dependencies
# RUN cd /root/dokku; make plugins

RUN curl --silent http://dl.gliderlabs.com/herokuish/latest/linux_x86_64.tgz | tar -xzC $(PREBUILT_STACK_URL)
RUN wget -O /root/buildstep.tar.gz $(grep PREBUILT_STACK_URL /root/dokku/Makefile | head -n1 | cut -d' ' -f3)

VOLUME ["/home/dokku","/var/lib/docker"]

ENV HOME /root
WORKDIR /root
ADD ./setup.sh /root/setup.sh
ADD ./wrapdocker /usr/local/bin/wrapdocker
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
RUN touch /root/.firstrun

EXPOSE 22
EXPOSE 80
EXPOSE 443

CMD ["bash", "/root/setup.sh"]
