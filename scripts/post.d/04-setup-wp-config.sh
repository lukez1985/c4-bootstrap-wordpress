#!/bin/bash

if [ ! -f /var/www/wordpress/wp-config.php ]
then
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

# remove the empty salts
sed -n '/unique/!p' -i /var/www/wordpress/wp-config.php
# really nasty hack to fix no permission error if this is not the last line of the config
sed -n '/require_once/!p' -i /var/www/wordpress/wp-config.php

# get new random salts
curl https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/wordpress/wp-config.php

# Change values of db in config file

sed -i s/database_name_here/bootstrapwp/ /var/www/wordpress/wp-config.php
sed -i s/username_here/bootstrap_user/ /var/www/wordpress/wp-config.php

# add support to change URL of site

echo " "  >> /var/www/wordpress/wp-config.php
echo "#Change this to your URL if you are moving the site from a temp URL to a final URL"  >> /var/www/wordpress/wp-config.php
echo "#define('WP_HOME','http://example.com');"  >> /var/www/wordpress/wp-config.php
echo "#define('WP_SITEURL','http://example.com');"  >> /var/www/wordpress/wp-config.php

# really nasty hack to fix no permission error if this is not the last line of the config
echo " "  >> /var/www/wordpress/wp-config.php
echo "@require_once(ABSPATH . 'wp-settings.php');" >> /var/www/wordpress/wp-config.php

# generate new password
passwd=`pwgen 10 1`
else
# use existing password
passwd=`cat /var/www/wordpress/wp-config.php | grep DB_PASSWORD | awk -F "'" '{print $4}'`
fi

# set the db up

mysqladmin -u root create bootstrapwp
mysql -u root -e "GRANT ALL PRIVILEGES ON bootstrapwp.* TO bootstrap_user@'localhost' IDENTIFIED by '${passwd}'";
mysqladmin -u root flush-privileges

## Set password in config file

sed -i s/password_here/${passwd}/ /var/www/wordpress/wp-config.php

## restore old DB if alvailable

if [ -f /var/tmp/sql/00-bootstrapwp.sql ];
then
    mysql -u root -D bootstrapwp < /var/tmp/sql/00-bootstrapwp.sql
fi

