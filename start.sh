#!/bin/sh

# Database
/bin/sh /startup/init_db.sh

# WordPress
/bin/sh /startup/install_wordpress.sh
/bin/sh /startup/init_wordpress.sh

# start daemon
/usr/bin/supervisord -n
