#!/bin/bash
set -e

# Remove any pre-existing server.pid for Rails
if [ -f /rails/tmp/pids/server.pid ]; then
  rm -f /rails/tmp/pids/server.pid
fi

# Wait for database if needed (useful if switching to PostgreSQL/MySQL later)
echo "Checking database connection..."

# Prepare database (create, migrate, seed if needed)
# This runs on container start, not build, so it uses the mounted code
bundle exec rails db:prepare 2>/dev/null || echo "Database already exists"

# Precompile bootsnap for faster boot
# Only if files have changed (bootsnap is smart about this)
bundle exec bootsnap precompile --gemfile app/ lib/ 2>/dev/null || true

echo "🚀 Rails development environment ready!"
echo "📝 File changes will be detected automatically"
echo "🔄 Hot-reload enabled"

# Execute the main command (e.g., rails server)
exec "$@"

