FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>


RUN yum -y install epel-release; yum clean all
RUN \
	yum -y install \
		php php-common \
		php-mbstring \
		php-mcrypt \
		php-devel \
		php-xml \
		php-mysqlnd \
		php-pdo \
		php-opcache --nogpgcheck \
		php-bcmath \

		`# install the following PECL packages:` \
		php-pecl-memcached \
		php-pecl-mysql \
		php-pecl-xdebug \
		php-pecl-zip \
		php-pecl-amqp --nogpgcheck \
		mariadb mariadb-server mariadb-client nginx pwgen python-setuptools curl git tar \

RUN curl 'https://setup.ius.io/' -o setup-ius.sh
RUN bash setup-ius.sh
RUN yum remove -y php-fpm php-cli php-common
RUN yum install -y php70u-fpm-nginx php70u-cli php70u-mysqlnd

ADD ./start.sh /start.sh
ADD ./nginx-site.conf /nginx.conf
RUN mv /nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf
RUN echo %sudo ALL=NOPASSWD: ALL >> /etc/sudoers
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz
RUN mv /wordpress/* /usr/share/nginx/html/.
RUN chown -R apache:apache /usr/share/nginx/
RUN chmod 755 /start.sh
RUN mkdir /var/run/sshd

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]

