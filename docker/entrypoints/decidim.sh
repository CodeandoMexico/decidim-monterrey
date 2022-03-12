#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

# Decidim
if [ -f /decidim/tmp/pids/server.pid ]; then
  rm /decidim/tmp/pids/server.pid
fi
exec bundle exec "$@"
