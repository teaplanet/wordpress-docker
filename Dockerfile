FROM ubuntu:12.04
MAINTAINER Ken(@teaplanet)

# upstart on Docker
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# mount
RUN cat /proc/mounts > /etc/mtab

# OS
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install vim curl pwgen unzip less supervisor ntpdate python-software-properties sudo

## timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Application repositories
## nginx
RUN add-apt-repository -y ppa:nginx/stable

## PHP
RUN add-apt-repository -y ppa:ondrej/php5

## MariaDB
#RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
#RUN echo "deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu precise main" >> /etc/apt/sources.list.d/mariadb.list
#RUN echo "deb-src http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu precise main" >> /etc/apt/sources.list.d/mariadb.list

RUN apt-get update
RUN apt-get -y upgrade


# install & setup
## ssh
RUN apt-get -y install ssh
RUN update-rc.d ssh defaults
RUN mkdir /var/run/sshd
ADD ./supervisor/sshd.conf /etc/supervisor/conf.d/sshd.conf

## nginx
RUN apt-get -y install nginx
RUN service nginx stop
RUN update-rc.d nginx disable

RUN sed -i "/pid;/a\daemon off;" /etc/nginx/nginx.conf
ADD ./supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD ./nginx-site /etc/nginx/sites-available/default

## PHP5
RUN apt-get -y install php5-fpm php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
RUN service php5-fpm stop

RUN sed -i "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
ADD ./supervisor/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf

## MariaDB
#RUN echo mariadb-server mysql-server/root_password password password | debconf-set-selections
#RUN echo mariadb-server mysql-server/root_password_again password password | debconf-set-selections
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

## MySQL
RUN echo mysql-server mysql-server/root_password password '' | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again password '' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
RUN service mysql stop
RUN update-rc.d mysql disable

RUN sed -i "/^innodb_buffer_pool_size*/ s|=.*|= 128M|" /etc/mysql/my.cnf
RUN sed -i "s/log_slow_verbosity/#log_slow_verbosity/" /etc/mysql/my.cnf
ADD ./supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf

## user
RUN useradd -d /home/ken -g users -k /etc/skel -m -s /bin/bash ken
RUN yes password | passwd ken
RUN echo "ken	ALL=(ALL:ALL) ALL" | visudo -c -f /etc/sudoers.d/ken
RUN chmod 440 /etc/sudoers.d/ken

ADD ./start.sh /
ADD ./startup /startup

CMD ["/bin/sh", "/start.sh"]
