# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.0

# ============================================
# BASE - Common dependencies for all stages
# ============================================
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /app

# Install base packages needed for all stages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ============================================
# DEVELOPMENT - Hot reload with volume mounts
# ============================================
FROM base as development

# Install packages needed for development
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Install gems (including development/test groups)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code (will be overridden by volume mount in docker-compose)
COPY . .

# Expose port
EXPOSE 3000

# Start server and dartsass watcher using Procfile.dev
CMD ["bash", "-c", "bundle exec foreman start -f Procfile.dev"]

# ============================================
# BUILD - Compile assets for production
# ============================================
FROM base as build

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install production gems only
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ============================================
# STAGING - Test production build locally
# ============================================
FROM base as staging

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Copy built artifacts from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Expose port
EXPOSE 3000

# Start the server
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

# ============================================
# PRODUCTION - Optimized for Fly.io
# ============================================
FROM base

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Copy built artifacts from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp && \
    chown -R rails:rails /app && \
    chmod -R 755 /app
USER rails:rails

# Expose port
EXPOSE 3000

# Start the server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
