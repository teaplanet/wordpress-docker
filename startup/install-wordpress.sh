#!/bin/sh

if [ ! -e /blog/wordpress ]; then
	cd /blog
	curl -o /blog/latest-ja.zip http://ja.wordpress.org/latest-ja.zip
	unzip /blog/latest-ja.zip -d /blog
	rm /blog/latest-ja.zip

	chown -R www-data:www-data /blog/wordpress
fi
