#!/bin/bash

# Switch to PostgreSQL user and execute SQL
sudo -u postgres psql -c "CREATE ROLE loftwah WITH LOGIN PASSWORD 'password';"
sudo -u postgres psql -c "ALTER ROLE loftwah CREATEDB;"

# Change password
# sudo -u postgres psql -c "ALTER USER loftwah WITH PASSWORD 'new_password_here';"


# Create and initialize the database
cd ..
bin/rails db:create db:migrate
