FROM python:3.7-slim

RUN apt-get update                                                  && \
    apt-get install -y gcc make build-essential                     && \
    apt-get install -y git             && \
    apt-get clean                                                   && \
    apt-get remove -y build-essential

RUN git clone https://github.com/clarissalimab/rasa-ptbr-boilerplate.git

RUN mkdir /app
RUN mkdir /app/bot
RUN cp -r ./rasa-ptbr-boilerplate/bot /app/bot/
RUN mkdir /app/modules
RUN cp -r ./rasa-ptbr-boilerplate/modules /app/modules/
RUN cp -r ./rasa-ptbr-boilerplate/requirements.txt /app/requirements.txt
RUN cp ./rasa-ptbr-boilerplate/server.sh /app/server.sh
WORKDIR /app
RUN ls -r bot

RUN python -m pip install --upgrade pip                             && \
    pip install --no-cache-dir -r requirements.txt && \
    python -c "import nltk; nltk.download('stopwords');"            && \
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

CMD rasa run actions --actions actions -vv

RUN find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

RUN rasa train -vv --config /app/bot/config.yml

ENTRYPOINT ["/app/server.sh"]