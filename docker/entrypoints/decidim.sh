#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

# Background process para el envío de emails
if [ -f /decidim/tmp/pids/delayed_job.pid ]; then
  rm /decidim/tmp/pids/delayed_job.pid
fi
bundle exec bin/delayed_job start

# Background process para la actualización de estadísticas y las tablas de datos abiertos
if [ -f /decidim/tmp/pids/clockwork.pid ]; then
  rm /decidim/tmp/pids/clockwork.pid
fi
bundle exec clockwork config/clockwork.rb

# Decidim
if [ -f /decidim/tmp/pids/server.pid ]; then
  rm /decidim/tmp/pids/server.pid
fi
exec bundle exec "$@"
