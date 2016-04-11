#!/bin/sh

set -eu

name=`whoami`
if [ $name != "apps" ]; then
  echo "Error: This User denied."
  exit 1
fi

case $1 in
  production) ;;
  *)
  echo "Error: RAILS_ENV value required. Usage: $0 <production>"
  exit 1
  ;;
esac

RAILS_ENV=${1}

cd /home/apps/aniradi.me

echo "> Stop unicorn..."
service unicorn stop

echo "> Pull git repo from GitHub..."
git pull

echo "> Install bundle..."
./bin/bundle install --path vendor/bundle

echo "> Migrate database..."
./bin/rake db:migrate RAILS_ENV=${RAILS_ENV}

echo "> Seed database..."
./bin/rake db:seed RAILS_ENV=${RAILS_ENV}

echo "> Precompile assets..."
./bin/rake assets:precompile RAILS_ENV=${RAILS_ENV}

echo "> Update crontab..."
./bin/bundle exec whenever -s "environment=${RAILS_ENV}" --update-cron

echo "> Restart unicorn..."
service unicorn restart
