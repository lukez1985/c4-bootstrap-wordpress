#!/bin/bash
# Works with themes from wordpress.org only!!!!!

if [[ -f scripts/post.d/themes ]]
then
    DIR="/var/www/wordpress/wp-content/themes"
    
    if [ -f /var/www/wordpress/wp-config.php ]; then
        echo "Installing plugins"
        for i in `cat scripts/post.d/plugins`; do
            echo Installing $i
            wget --directory-prefix=${DIR} $i
            theme=`echo $i | awk 'BEGIN {FS="/"} { print $7 }'`
            unzip ${DIR}/${theme} -d ${DIR}/
        done
    else
        echo "Wordpress not installed correctly!"
        exit 1
    fi
else
    echo "No Plugins Configured for install"
    exit 1
fi
