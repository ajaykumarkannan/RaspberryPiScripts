#!/bin/bash

docker pull pihole/pihole:latest
docker stop pihole
docker rm pihole

docker run -d \
    --name pihole \
    -p 10.6.0.1:53:53/tcp -p 10.6.0.1:53:53/udp \
    -p 10.6.0.1:80:80 \
    -p 10.6.0.1:443:443 \
    -e TZ="America/Toronto" \
    -v "$(pwd)/etc-pihole/:/etc/pihole/" \
    -v "$(pwd)/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    pihole/pihole:latest

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
