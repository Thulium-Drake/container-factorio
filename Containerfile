FROM debian:stable-slim

ARG VERSION=stable

# Get dependencies
RUN apt-get update -yq \
  && apt-get install -y \
     curl xz-utils tar \
  && apt-get clean

# Download game and extract version
RUN mkdir /game
RUN curl -L https://factorio.com/get-download/$VERSION/headless/linux64 | tar xJf - --strip-components=1 -C /game


ADD --chmod=0755 start.sh /

ENTRYPOINT /start.sh
