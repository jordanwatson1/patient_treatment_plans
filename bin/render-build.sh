#!/usr/bin/env bash
set -o errexit

# --- Make Yarn 4 available (Render image ships with Yarn 1) ---
corepack enable
# Ensure Corepack shims are used instead of global Yarn 1:
export PATH="$HOME/.local/share/corepack/shims:$PATH"
corepack prepare yarn@4.9.2 --activate

echo "Node: $(node -v)"
echo "Yarn path: $(which yarn)"
yarn --version

# JS deps (allow writes in CI)
YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install

# --- Ruby deps & assets ---
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free tier trick: run migrations during build
bundle exec rails db:migrate
