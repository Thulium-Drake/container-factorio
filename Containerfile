FROM debian:stable-slim

ARG VERSION=stable

# Get dependencies
RUN apt update -yq \
  && apt install -y \
     curl xz-utils tar

# Download game and extract version
RUN mkdir /game
RUN curl -L https://factorio.com/get-download/$VERSION/headless/linux64 | tar xJf - --strip-components=1 -C /game
