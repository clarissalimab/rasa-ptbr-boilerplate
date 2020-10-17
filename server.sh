#!/bin/sh

if [ -z "$PORT"]
then
  PORT=5005
fi

rasa run -m app/models/ -vv --port $PORT --credentials app/bot/credentials.yml --endpoints app/bot/endpoints.yml