#!/bin/bash

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -uroot -e "CREATE USER IF NOT EXISTS wordpressuser@localhost IDENTIFIED BY 'password';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;"
mysql -uroot -e "FLUSH PRIVILEGES;"