FROM python:3.7-slim

RUN apt-get update                                                  && \
    apt-get install -y gcc make build-essential                     && \
    apt-get install -y git             && \
    apt-get clean                                                   && \
    apt-get remove -y build-essential

RUN git clone https://github.com/clarissalimab/rasa-ptbr-boilerplate.git

RUN python -m pip install --upgrade pip                             && \
    pip install --no-cache-dir -r ./rasa-ptbr-boilerplate/requirements.txt && \
    python -c "import nltk; nltk.download('stopwords');"            && \
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

RUN mkdir /bot
COPY -r ./rasa-ptbr-boilerplate/bot /bot
WORKDIR /bot
RUN echo ls

CMD rasa run actions --actions actions -vv

RUN find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

RUN rasa train -vv
RUN mkdir /modules
COPY -r ./rasa-ptbr-boilerplate/modules /modules

ENTRYPOINT ["./rasa-ptbr-boilerplate/server.sh"]