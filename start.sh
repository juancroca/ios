#!/usr/bin/env bash

echo "Installing bundler"
gem install bundler
 
echo "Bundling gems"
bundle install --jobs 4 --retry 3
 
echo "Setting up new db if one doesn't exist"
bin/rake db:version || { bundle exec rake db:setup; }
 
echo "Removing contents of tmp dirs"
bin/rake tmp:clear
 
echo "Starting app server"
bundle exec rails s -p 3000