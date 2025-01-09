#!/bin/bash
# Start Factorio Server

# Ensure we have dirs for saves and mods
mkdir -p /data/{saves,mods}

# Test if we have settings files, if not, copy them
if ! test -f /data/map-gen-settings.json
then
    echo "map-gen-settings not found, copy template"
    cp /game/data/map-gen-settings.example.json /data/map-gen-settings.json
fi

if ! test -f /data/map-settings.json
then
    echo "map-settings not found, copy template"
    cp /game/data/map-settings.example.json /data/map-settings.json
fi

if ! test -f /data/server-settings.json
then
    echo "server-settings not found, creating new"
    cp /game/data/server-settings.example.json /data/server-settings.json
fi

if ! test -f /data/server-adminlist.json
then
    echo "server-adminlist not found, creating new empty list"
    echo "[]" > /data/server-adminlist.json
fi

if ! test -f /data/server-banlist.json
then
    echo "server-banlist not found, creating new empty list"
    echo "[]" > /data/server-banlist.json
fi

# Test if we have a save, if not, create it
if ! test -f /data/saves/server.zip
then
    echo "Save not found, creating new"
    /game/bin/x64/factorio --map-gen-settings /data/map-gen-settings.json --map-settings /data/map-settings.json --create /data/saves/server.zip
fi

echo "Starting server"
/game/bin/x64/factorio --start-server /data/saves/server.zip --server-settings /data/server-settings.json --mod-directory /data/mods  --server-adminlist /data/server-adminlist.json --server-banlist /data/server-banlist.json
