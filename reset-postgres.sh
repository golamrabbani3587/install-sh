#!/bin/bash

# Stop PostgreSQL service
sudo systemctl stop postgresql

# Remove PostgreSQL and related packages
sudo apt-get --purge remove -y postgresql postgresql-*
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Remove PostgreSQL directories
sudo rm -rf /etc/postgresql/
sudo rm -rf /var/lib/postgresql/
sudo rm -rf /var/log/postgresql/

# Remove PostgreSQL user and group
sudo deluser --remove-home postgres
sudo delgroup postgres

# Update package list
sudo apt update

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"
sudo -u postgres psql -c "ALTER USER postgres WITH SUPERUSER;"


echo "PostgreSQL has been reinstalled successfully."
# /etc/postgresql/16/main/postgresql.conf
# /etc/postgresql/16/main/pg_hba.conf