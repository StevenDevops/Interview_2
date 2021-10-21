#!/bin/sh

# Set parametter for the test
export SECRET_KEY="steven#testing"
export FLASK_CONFIG="development"
export DATABASE_URL='postgres://steven:12345@postgres:5432/recipe_db'

# DB migration
python manage.py db init
python manage.py db migrate
python manage.py db upgrade

# Run server and allow to recive the request from outside
python manage.py runserver -h 0.0.0.0 -p 5000