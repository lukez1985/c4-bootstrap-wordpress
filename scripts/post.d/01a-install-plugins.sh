#!/bin/bash

if [[ -f scripts/post.d/plugins ]]
then
    DIR="/var/www/wordpress/wp-content/plugins"
    
    if [ -f /var/www/wordpress/wp-config.php ]; then
        echo "Installing plugins"
        for i in `cat scripts/post.d/plugins`; do
            echo Installing $i
            wget --directory-prefix=${DIR} $i
            plugin=`echo $i | awk 'BEGIN {FS="/"} { print $5 }'`
            unzip ${DIR}/${plugin} -d ${DIR}/
        done
    else
        echo "Wordpress not installed correctly!"
        exit 1
    fi
else
    echo "No Plugins Configured for install"
    exit 1
fi
