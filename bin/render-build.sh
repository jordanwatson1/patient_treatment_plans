#!/usr/bin/env bash
set -o errexit

# If you’re using Yarn 1 or npm, keep whatever you had above this line for JS deps ...

# Ensure we build & migrate against production
export RAILS_ENV=production
export RACK_ENV=production

echo "Node: $(node -v)"
echo "Env:  RAILS_ENV=${RAILS_ENV} RACK_ENV=${RACK_ENV}"
ruby -e 'puts "DATABASE_URL present? #{!!ENV["DATABASE_URL"]}"'

# JS deps
# (pick one; examples)
yarn install --check-files || npm ci

# Ruby deps & assets
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free plan: run migrations at build time
bundle exec rails db:migrate
