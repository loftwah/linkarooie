# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        libvips \
        pkg-config \
        nodejs \
        npm \
        imagemagick \
        fonts-liberation \
        fonts-freefont-ttf \
        fonts-dejavu \
        fontconfig

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JavaScript dependencies
RUN npm install

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
ENV PRECOMPILE_ASSETS=true
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
ENV PRECOMPILE_ASSETS=false

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        curl \
        libsqlite3-0 \
        libvips \
        imagemagick \
        fonts-liberation \
        sqlite3 \
        libsqlite3-dev \
        fonts-freefont-ttf \
        fonts-dejavu \
        fontconfig && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application, and node modules
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create a directory for the SQLite database
RUN mkdir -p /rails/storage

# Ensure required directories exist and have the correct permissions
RUN mkdir -p public/assets public/packs public/uploads/og_images public/avatars && \
    useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

# Run and own only the runtime files as a non-root user for security
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]