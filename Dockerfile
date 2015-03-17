FROM ubuntu:trusty

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -q -y --no-install-recommends \
  build-essential checkinstall git vim screen wget man curl tmux openssh-server \
  python-dev erlang libicu-dev software-properties-common libsqlite3-dev

# Ack
RUN curl http://beyondgrep.com/ack-2.14-single-file > /usr/bin/ack && chmod 0755 /usr/bin/ack
RUN curl "https://raw.githubusercontent.com/rupa/z/master/z.sh" > /usr/local/share/z.sh

# Ruby
RUN cd /tmp && \
  wget --no-check-certificate -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz && \
  tar -xzvf chruby-0.3.9.tar.gz && \
  cd chruby-0.3.9/ && \
  make install
RUN cd /tmp && \
  wget --no-check-certificate -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
  tar -xzvf ruby-install-0.5.0.tar.gz && \
  cd ruby-install-0.5.0/ && \
  make install
RUN ruby-install ruby 1.9.3-p545
RUN /bin/bash -c 'source /usr/local/share/chruby/chruby.sh && \
  chruby 1.9.3 && \
  gem install --no-ri --no-rdoc bundler'

# PHP and Node.js
RUN add-apt-repository -y ppa:ondrej/php5
RUN gpg -q --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 4F4EA0AAE5267A6C && \
  gpg -q -a --export 4F4EA0AAE5267A6C | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y php5-cli nodejs

# Keyczar
RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -s -o - | python
RUN easy_install python-keyczar

RUN mkdir -p /var/run/sshd

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN mkdir /p
VOLUME ['/p']

RUN useradd --create-home --shell /bin/bash dev

ADD files /
RUN chown -R dev:dev /p /home/dev

CMD ["/usr/sbin/sshd", "-d"]
EXPOSE 22
