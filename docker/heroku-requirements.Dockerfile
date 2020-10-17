FROM python:3.7-slim

COPY ./requirements.txt .

RUN apt-get update                                                  && \
    apt-get install -y gcc make build-essential                     && \
    python -m pip install --upgrade pip                             && \
    pip install --no-cache-dir -r ./requirements.txt             && \
    python -c "import nltk; nltk.download('stopwords');"            && \
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf    && \
    apt-get clean                                                   && \
    apt-get remove -y build-essential

COPY . .

CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT