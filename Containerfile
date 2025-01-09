FROM debian:stable-slim

ARG GAME_VERSION=stable

# Get dependencies
RUN apt-get update -yq \
  && apt-get install -y \
     curl xz-utils tar \
  && apt-get clean

# Install game server
RUN mkdir /game \
  && curl -L https://factorio.com/get-download/$GAME_VERSION/headless/linux64 | tar xJf - --strip-components=1 -C /game \
  && mkdir /data/saves \
  && rm -rf /game/saves \
  && ln -s /data/saves /game/saves

ADD --chmod=0755 start.sh /

ENTRYPOINT /start.sh
