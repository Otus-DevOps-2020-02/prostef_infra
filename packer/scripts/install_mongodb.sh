#!/bin/bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list

apt-get update 2>/dev/null | grep packages | cut -d '.' -f 1
apt-get install mongodb-org -y

systemctl start mongod
systemctl enable mongod
