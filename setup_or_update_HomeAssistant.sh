#!/bin/bash

echo "Updating home-assistant image"
UPDATE_LOG=`docker pull homeassistant/home-assistant:stable`  # if this returns "Image is up to date" then you can stop here

if [ `echo $UPDATE_LOG | grep -v "Image is up to date"` ]; then
  if docker ps -a | grep "home-assistant" ; then
    echo "Deleting old containers"
    docker stop home-assistant  # stop the running container
    docker rm home-assistant  # remove it from Docker's list of containers
  fi
  echo "Starting the docker container"
  docker run -d --name="home-assistant" -v /home/pi/home-assistant:/config -v /etc/localtime:/etc/localtime:ro --net=host homeassistant/home-assistant:stable  # finally, start a new one
  echo "Cleaning up any dangling images"
  docker rmi $(docker images -f "dangling=true" -q)
else
  echo "Already up to date"
fi
