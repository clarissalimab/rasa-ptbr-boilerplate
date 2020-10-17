FROM python:3.7-slim

RUN mkdir tmp
COPY ./requirements.txt /tmp

RUN apt-get update                                                  && \
    apt-get install -y gcc make build-essential                     && \
    python -m pip install --upgrade pip                             && \
    pip install --no-cache-dir -r /tmp/requirements.txt             && \
    python -c "import nltk; nltk.download('stopwords');"            && \
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf    && \
    apt-get clean                                                   && \
    apt-get remove -y build-essential

RUN mkdir bot
COPY ./bot /bot

WORKDIR /bot

HEALTHCHECK --interval=300s --timeout=60s --retries=5 \
  CMD curl -f http://0.0.0.0:5055/health || exit 1

CMD rasa run actions --actions actions -vv

RUN mkdir modules
COPY ./modules /modules

RUN find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf