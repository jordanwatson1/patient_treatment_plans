#!/usr/bin/env bash
set -o errexit

# Ensure our wrapper is found first
export PATH="./bin:$PATH"

echo "Node: $(node -v)"
echo "Yarn (which): $(which yarn)"   # should be /opt/render/project/src/bin/yarn
echo "Yarn (v): $(yarn --version)"   # should be 4.9.2

# JS deps
YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install

# Ruby deps & assets
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free tier trick: run migrations during build
bundle exec rails db:migrate
