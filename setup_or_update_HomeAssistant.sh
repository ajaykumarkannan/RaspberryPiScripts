#!/bin/bash

docker pull homeassistant/home-assistant:stable
docker run -d --restart=always --name="home-assistant" -v /home/pi/home-assistant:/config -v /etc/localtime:/etc/localtime:ro --net=host homeassistant/home-assistant:stable  # finally, start a new one
docker rmi $(docker images -f "dangling=true" -q)
