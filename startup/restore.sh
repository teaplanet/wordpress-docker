#!/bin/sh

BLOG_DIR=/blog
WORDPRESS_DIR=$BLOG_DIR/wordpress
RESTORE_DIR=$BLOG_DIR/restore

if [ -d $RESTORE_DIR ]; then
	for file in $RESTORE_DIR/*.tar.gz
	do
		tar xfvz $file -C $RESTORE_DIR
	done

	if [ -d $RESTORE_DIR/wordpress ]; then
		cp -R $RESTORE_DIR/wordpress/wp-content/* $WORDPRESS_DIR/wp-content
		chown -R www-data:www-data $WORDPRESS_DIR/wp-content
	fi

	/usr/bin/mysqld_safe &
	sleep 10
	for file in $RESTORE_DIR/*.dump
	do
		/usr/bin/mysql -u wordpress -p`cat /blog/wordpress-db-pw.txt` wordpress < $file
	done
	killall mysqld

	mv $RESTORE_DIR ${RESTORE_DIR}.done_`date +%Y-%m-%d_%H%M`
fi
