#!/bin/bash
# Does the user want the latest version
if [ -n "$EDGE" ]
then
echo "EDGE variable found"
  if [ "$EDGE" == "1" ]; then
	echo "EDGE=1"
		if [ -f /config/rutorrent/.gitignore ]; then
			echo "prev GIT version detected, updating"
			git -C /config/rutorrent/ pull
			chown -R torrent:www-data /config/rutorrent
			exit
		else
			echo "no prev GIT version detected, cloning"
			rm -rf /config/rutorrent
			git clone -b master https://github.com/Novik/ruTorrent.git /config/rutorrent
			rm /config/rutorrent/conf/config.php
			cp /config.php /config/rutorrent/conf/config.php
			chown -R torrent:www-data /config/rutorrent
			# fixing program paths php, curl, gzip, id
			sed -i "s+\"php\" \t=> '',+\"php\" => '/usr/bin/php',+g" /config/rutorrent/conf/config.php
			sed -i "s+\"curl\"\t=> '',+\"curl\" => '/usr/bin/curl',+g" /config/rutorrent/conf/config.php
			sed -i "s+\"gzip\"\t=> '',+\"gzip\" => '/bin/gzip',+g" /config/rutorrent/conf/config.php
			sed -i "s+\"id\"\t=> '',+\"id\" => '/usr/bin/id',+g" /config/rutorrent/conf/config.php
			# adding paths that are not included, python, pgrep, sox
			sed -i "s+\"stat\"\t=> '',+\"stat\" => '/usr/bin/stat',\n\t\t\"python\" => '/usr/bin/python3',\n\t\t\"pgrep\" => '/usr/bin/pgrep',\n\t\t\"sox\" => '/usr/bin/sox',+g" /config/rutorrent/conf/config.php
			exit
		fi
  elif [ "$EDGE" == "0" ]
  then
    echo "edge not requested, using ruTorrent and Plugins release 3.6"
  exit
  else
    echo "EDGE variable incorrect; Must be uppercase and can be 0 or 1 only"
    exit
  fi
else
  echo -e "EDGE variable  not found\n"
fi