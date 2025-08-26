#!/usr/bin/env bash
set -o errexit

# --- Make Yarn 4 available (Render image ships with Yarn 1) ---
# Corepack is included with Node >=16.9; this activates Yarn 4 per package.json
corepack enable
corepack prepare yarn@4.9.2 --activate
yarn --version

# Install JS deps; disable "immutable" to allow lockfile/node_modules on CI
# (Yarn 4 only fails immutability if the lockfile needs changes)
YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install

# --- Ruby deps & assets ---
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free tier trick: run migrations during build
bundle exec rails db:migrate
