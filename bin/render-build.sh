#!/usr/bin/env bash
set -o errexit

# Put our repo's bin/ first so "yarn" resolves to bin/yarn (the wrapper)
export PATH="./bin:$PATH"

# (Optional) Also prepare Corepack in case you call it directly
corepack enable
corepack prepare yarn@4.9.2 --activate

echo "Node: $(node -v)"
echo "Yarn (which): $(which yarn)"      # should print .../project/src/bin/yarn
echo "Yarn (v): $(yarn --version)"       # should print 4.9.2
echo "Corepack Yarn (v): $(corepack yarn --version)"

# JS deps (allow lockfile writes on CI)
YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install

# Ruby deps & assets
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free tier trick: run migrations during build
bundle exec rails db:migrate
