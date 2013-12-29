# mount
RUN cat /proc/mounts > /etc/mtab

# OS
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install vim curl pwgen unzip less supervisor ntpdate python-software-properties

## timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


# Application repositories
## nginx
RUN add-apt-repository -y ppa:nginx/stable

## PHP
RUN add-apt-repository -y ppa:brianmercer/php5

## MariaDB
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.0/ubuntu precise main'

RUN apt-get update
RUN apt-get -y upgrade


# setup
## nginx
RUN apt-get -y install nginx
RUN service nginx stop
RUN update-rc.d nginx disable

RUN sed -i "/pid;/a\daemon off;" /etc/nginx/nginx.conf
ADD ./supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD ./nginx-site /etc/nginx/sites-available/default

## PHP5
RUN apt-get -y install php5-fpm php5-mysql
RUN service php5-fpm stop
RUN update-rc.d php5-fpm disable

RUN sed -i "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
ADD ./supervisor/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf

## MariaDB
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y mariadb-server
RUN service mysql stop
RUN update-rc.d mysql disable

RUN sed -i "s/\(datadir[^=]\+= \).\+/\1\/blog\/db/" /etc/mysql/my.cnf

## WordPress
RUN mkdir -p /blog/db
RUN cd /blog
RUN curl -O http://ja.wordpress.org/latest-ja.zip
RUN unzip latest-ja.zip
RUN rm latest-ja.zip

### change owner
RUN chown -R www-data:www-data wordpress
RUN chown -R mysql:mysql /blog/db

# run options
EXPOSE 10022:22
EXPOSE 10080:80

VOLUME ["/data", "/blog"]

CMD ["/usr/bin/supervisord"]
