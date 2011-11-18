#!/bin/bash

# Hack Tyler project server setup script for Ubuntu 11.10
# Based on the PANDA Project server script
# Must be executed with sudo!

CONFIG_URL="https://raw.github.com/gist/1375490"

# Setup environment variables
echo "export DEPLOYMENT_TARGET=\"deployed\"" > /home/ubuntu/.bash_profile
export DEPLOYMENT_TARGET="deployed"

# Make sure SSH comes up on reboot
ln -s /etc/init.d/ssh /etc/rc2.d/S20ssh
ln -s /etc/init.d/ssh /etc/rc3.d/S20ssh
ln -s /etc/init.d/ssh /etc/rc4.d/S20ssh
ln -s /etc/init.d/ssh /etc/rc5.d/S20ssh

# Install outstanding updates
apt-get --yes update
apt-get --yes upgrade

# Configure unattended upgrades
wget $CONFIG_URL/10periodic -O /etc/apt/apt.conf.d/10periodic
service unattended-upgrades restart

# Install required packages
apt-get install --yes git postgresql python2.7-dev git nginx build-essential python-virtualenv libpq-dev memcached pgpool2
pip install uwsgi

# Setup uWSGI
adduser --system --no-create-home --disabled-login --disabled-password --group uwsgi  
mkdir /var/run/uwsgi
chown uwsgi:uwsgi /var/run/uwsgi

# Setup nginx
wget $CONFIG_URL/nginx.conf -O /etc/nginx/nginx.conf
initctl reload-configuration
service nginx restart

# Setup Postgres
wget $CONFIG_URL/pg_hba.conf -O /etc/postgresql/9.1/main/pg_hba.conf
service postgresql restart

# Get code (as normal user)
sudo -u ubuntu mkdir /home/ubuntu/src
cd /home/ubuntu/src

# Setup directories 
mkdir /var/log/sites
chown -R uwsgi:uwsgi /var/log/sites

mkdir /mnt/uploads
chown uwsgi:uwsgi /mnt/uploads

mkdir /mnt/media
chown uwsgi:uwsgi /mnt/media

# Start serving
service uwsgi start

