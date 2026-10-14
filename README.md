# Factorio Container image

This image runs a Factorio headless dedicated server on a Debian stable base.
On startup it prepares a `/data` directory holding server settings, the save
file, and mods, then starts the server.

## Base & contents

- Base image: `debian:stable-slim`.
- `curl`, `xz-utils`, and `tar` are installed to download and unpack the game
  during the build.
- The Factorio headless server (linux64) is downloaded from
  `https://factorio.com/get-download/<GAME_VERSION>/headless/linux64` and
  extracted to `/game`.
- `/game/saves` is symlinked to `/data/saves`, so saves live on the mounted
  data volume.
- Working directory: `/` (none set). Entrypoint: `/start.sh`. Stop signal:
  `SIGINT`.

## Build

./build.sh

This fetches the latest stable game version from the Factorio download service
and builds the image tagged `factorio:latest`.

## Running the container

No environment variables are required; there are no API keys or external
services to configure.

At startup the container will check if the data directory mounted in the container already contains the required files to run the server. If not, it will copy these files from the server directory. If you already have files available, you can put them in the directory with the following names:

  * map-gen-settings.json
  * map-settings.json
  * server-settings.json

There also should be a saves directory (if you don't have one, it will be created for you)
  * saves/server.zip (the save file)

Last, but not least, put any mods you want to run on the server in the following folder:
  * mods/<mod files>

A sample command to run the container is:

podman run -it -v ./factorio-data:/data:Z -p 34197:34197/udp factorio:latest

## Configuration

All mutable state lives in `/data`, which you bind-mount from the host. On
first start `/start.sh` creates whatever is missing:

- `map-gen-settings.json`, `map-settings.json`, `server-settings.json` —
  copied from the game's `*.example.json` templates in `/game/data` if absent.
- `server-adminlist.json` and `server-banlist.json` — created empty (`[]`) if
  absent.
- `saves/` — created if absent; `saves/server.zip` is generated on first
  start if no save exists.
- `mods/` — created if absent; place mod archives here.

To use your own settings, pre-seed the bind-mounted directory with these files
before the first start (they are only copied when absent).

Build-time arguments:

- `GAME_VERSION` (default `stable`) — the Factorio version used in the download
  URL `https://factorio.com/get-download/<GAME_VERSION>/headless/linux64`.
  The `stable` default resolves to the current stable release; to pin a
  specific version, build with `--build-arg GAME_VERSION=<version>`.

The image exposes `34197/udp` (`EXPOSE 34197/udp`), declares `VOLUME /data`,
and sets no `ENV` directives.
