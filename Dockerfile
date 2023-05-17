# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:1.14.4

# Install required libraries on Alpine
# note: build-base required to run mix “make” for
# one of my dependecies (bcrypt)

WORKDIR /app

RUN apt update && \
  apt install nodejs npm -y

# Set environment to production
ENV MIX_ENV prod

# Install hex package manager and rebar
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix do local.hex --force, local.rebar --force

# Cache elixir dependecies and lock file
COPY mix.* ./

# Install and compile production dependecies
RUN mix do deps.get --only prod
RUN mix deps.compile

# Copy all application files
COPY . ./

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest
ENV SECRET_KEY_BASE=test

EXPOSE 4000
CMD ["mix", "phx.server"]