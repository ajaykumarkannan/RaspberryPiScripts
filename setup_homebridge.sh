#!/bin/bash

docker pull oznu/homebridge
docker run --net=host --name=homebridge -e PUID=1000 -e PGID=1000  -e HOMEBRIDGE_CONFIG_UI=1   -e HOMEBRIDGE_CONFIG_UI_PORT=8080   -v ~/homebridge:/homebridge   oznu/homebridge
