#!/bin/sh

BLOG_DIR="/blog"
WORDPRESS_DIR="$BLOG_DIR/wordpress"

if [ ! -f $WORDPRESS_DIR/wp-config.php ]; then
	/usr/bin/mysqld_safe --skip-grant-tables &
	sleep 10s

	MYSQL_PASSWORD=`pwgen -c -n -1 12`
	WORDPRESS_DB="wordpress"
	WORDPRESS_USER="wordpress"
	WORDPRESS_PASSWORD=`pwgen -c -n -1 12`

	echo MySQL root password: $MYSQL_PASSWORD
	echo WordPress password : $WORDPRESS_PASSWORD
	echo $MYSQL_PASSWORD > $BLOG_DIR/mysql-root-pw.txt
	echo $WORDPRESS_PASSWORD > $BLOG_DIR/wordpress-db-pw.txt

	sed -e "s/database_name_here/$WORDPRESS_DB/
	s/username_here/$WORDPRESS_USER/
	s/password_here/$WORDPRESS_PASSWORD/
	/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" $WORDPRESS_DIR/wp-config-sample.php > $WORDPRESS_DIR/wp-config.php

	chown www-data:www-data $WORDPRESS_DIR/wp-config.php

	mysql -u root -e "use mysql; UPDATE user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root'; FLUSH PRIVILEGES;"
	mysql -u root --password=$MYSQL_PASSWORD -e "CREATE DATABASE $WORDPRESS_DB; GRANT ALL PRIVILEGES ON $WORDPRESS_DB.* TO '$WORDPRESS_USER'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
	killall mysqld
fi
