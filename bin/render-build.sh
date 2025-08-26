#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# On Render's Free plan, run migrations during build
bundle exec rails db:migrate
