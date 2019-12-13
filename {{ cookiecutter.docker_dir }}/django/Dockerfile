#
# Django image
#
FROM python:{{ cookiecutter.python_version }}

RUN wget -O - https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
ENV PATH="/root/.poetry/bin:${PATH}"
RUN echo "\n" | sh -c "$(curl https://salsa.debian.org/postgresql/postgresql-common/raw/master/pgdg/apt.postgresql.org.sh)"
RUN apt-get update && apt-get install -y \
    postgresql-client \
    gettext \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/app

RUN poetry config virtualenvs.create false

COPY poetry.lock .
COPY pyproject.toml .
RUN PIP_NO_CACHE_DIR=false poetry install

EXPOSE 8000/tcp

COPY docker/django/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-Wd", "manage.py", "runserver", "--nostatic", "0.0.0.0:8000"]
