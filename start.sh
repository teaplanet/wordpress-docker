#!/bin/sh

# Database
/bin/sh /startup/initdb.sh

# WordPress
/bin/sh /startup/install-wordpress.sh
/bin/sh /startup/init-wordpress.sh

# start daemon
/usr/bin/supervisord -n
