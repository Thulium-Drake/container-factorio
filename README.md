# Factorio Container image
This repo contains a setup for creating a Factorio container image based on Debian Stable.

It uses Gitea Actions (which in turn is based on Github Actions) to build the image and it will tag the container with whatever version it finds on the Factorio download API.

If you wish to build the container manually, please run the 'build.sh' script.

As of now, there's no means of providing a custom game version to the build script, but it can be done manually by adding the following command to 'podman build':

```
--build-arg VERSION=<my version here>
```

## Running the container
At startup the container will check if the data directory mounted in the container already contains the required files to run the server. If not, it will copy these files from the server directory. If you already have files available, you can put them in the directory with the following names:

  * map-gen-settings.json
  * map-settings.json
  * server-settings.json

There also should be a saves directory (if you don't have one, it will be created for you)
  * saves/server.zip (the save file)

Last, but not least, put any mods you want to run on the server in the following folder:
  * mods/<mod files>

A sample command to run the container is:

```
podman run -it -v /home/ansible/garbage/factorio:/data:Z -p 34197:34197 factorio:latest
```
