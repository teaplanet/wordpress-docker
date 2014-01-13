#!/bin/sh

DATADIR=/blog/db

sed -i "/^datadir*/ s|=.*|= $DATADIR|" /etc/mysql/my.cnf
if ! [ -d $DATADIR/mysql ]; then
	mkdir -p $DATADIR
	/usr/bin/mysql_install_db
	chown -R mysql:mysql $DATADIR
	chmod 700 $DATADIR
fi
