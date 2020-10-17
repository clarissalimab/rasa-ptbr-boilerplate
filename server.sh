#!/bin/sh

if [ -z "$PORT"]
then
  PORT=5005
fi

rasa run -m models/ -vv --port $PORT --credentials credentials.yml --endpoints endpoints.yml