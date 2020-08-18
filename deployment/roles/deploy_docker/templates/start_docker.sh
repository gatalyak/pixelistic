#!/bin/bash
docker login -u {{ DOCKER_USER }} -p  {{ DOCKER_PASS }}
cd deploy
docker-compose pull
docker-compose stop
docker-compose rm -f
