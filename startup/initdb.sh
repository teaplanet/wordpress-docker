#!/bin/sh

sed -i "/^datadir*/ s|=.*|= /blog/db|" /etc/mysql/my.cnf
if ! [ -d /blog/db/mysql ]; then
	mkdir -p /blog/db
	/usr/bin/mysql_install_db
	chown -R mysql:mysql /blog/db
	chmod 700 /blog/db
fi
