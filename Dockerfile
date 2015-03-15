FROM ubuntu:trusty
RUN apt-get install -y git

ADD files /

CMD /bin/bash
