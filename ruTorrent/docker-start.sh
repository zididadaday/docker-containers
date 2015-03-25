#!/bin/sh

# Move ruTorrent into /config and Symbolic Link for nginx
	mv -R /var/www/rutorrent /config/rutorrent
	ln -s /config/rutorrent /var/www/rutorrent

# Does the user want the edge version?
	/bin/bash /edge.sh

# Set up BASIC Auth and SSL
	/bin/bash /ssl.sh

# Check if config exists. If not, copy in the sample config
if [ -f /config/.rtorrent.rc ]; then
	echo "Using existing config file."
else
	echo "Creating config from template."
	cp  /rtorrent.rc /config/.rtorrent.rc
fi

# Continue Docker Start
chown -R torrent:users /config
chmod -R 777 /config

chown -R torrent:www-data /config/rutorrent

chown -R torrent:users /download
chmod -R 777 /download

mkdir /config/.rtorrentsession
chown torrent:www-data /config/.rtorrentsession
chmod 777 /config/.rtorrentsession

set -ex

service nginx start
service php5-fpm start

cd ~torrent
exec gosu torrent /rutorrent.sh

