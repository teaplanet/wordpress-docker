#!/bin/sh

BLOG_DIR=/blog
WORDPRESS_DIR=$BLOG_DIR/wordpress

if [ ! -e $WORDPRESS_DIR ]; then
	unzip /latest-ja.zip -d $BLOG_DIR
	chown -R www-data:www-data $WORDPRESS_DIR
fi
