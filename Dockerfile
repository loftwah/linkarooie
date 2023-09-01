# Use the official Ruby 3.2.2 image
FROM ruby:3.2.2

# Add NodeSource as a trusted source of Node.js packages
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# Install Node.js and npm
RUN apt-get install nodejs npm -y

# Optionally, install Yarn (recommended for Rails asset management)
RUN npm install --global yarn

# Set an environment variable to store where the app is installed to inside of the Docker image
ENV INSTALL_PATH /app

# Create the directory and set it as the working directory
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Use Bundler to bundle install the Ruby gems
# This step is done separately from adding the entire codebase to cache the Docker layer
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy over your application code
COPY . .

# Expose the port
EXPOSE 3000

# The command that starts your application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
