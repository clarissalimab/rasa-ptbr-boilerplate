FROM botrequirements

COPY ./bot/actions/actions.py /bot/actions/actions.py
COPY ./bot/Makefile /bot/Makefile

WORKDIR /bot

HEALTHCHECK --interval=300s --timeout=60s --retries=5 \
  CMD curl -f http://0.0.0.0:5055/health || exit 1

CMD rasa run actions --actions actions -vv
