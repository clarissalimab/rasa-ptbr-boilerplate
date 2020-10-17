FROM python:3.7-slim

RUN apt-get update                                                  && \
    apt-get install -y gcc make build-essential                     && \
    apt-get install -y git             && \
    python -m pip install --upgrade pip                             && \
    pip install --no-cache-dir rasa==1.10.10             && \
    pip install --no-cache-dir nltk==3.4.5             && \
    pip install --no-cache-dir gunicorn==20.0.4             && \
    python -c "import nltk; nltk.download('stopwords');"            && \
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf    && \
    apt-get clean                                                   && \
    apt-get remove -y build-essential

RUN git clone https://github.com/clarissalimab/rasa-ptbr-boilerplate.git

RUN mkdir /bot
RUN cp ./rasa-ptbr-boilerplate/bot /bot
WORKDIR /bot

HEALTHCHECK --interval=300s --timeout=60s --retries=5 \
  CMD curl -f http://0.0.0.0:5055/health || exit 1

CMD rasa run actions --actions actions -vv

RUN mkdir modules
COPY ./modules /modules

RUN find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf