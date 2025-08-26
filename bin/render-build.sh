#!/usr/bin/env bash
set -o errexit

echo "Node: $(node -v)"
echo "Yarn: $(yarn --version)"   # should print 1.22.22

yarn install --check-files

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
