#
# Image to calculate wheels' versions
#
# Calculating package versions in a separate build avoids running
# builder images everytime poetry.lock or pyproject.toml change.
#
FROM python:{{ cookiecutter.python_version }}-alpine{{ cookiecutter.alpine_version }} as versions

RUN pip --no-cache-dir install -U poetry

WORKDIR /srv/wheels

RUN poetry config settings.virtualenvs.create false

COPY poetry.lock .
COPY pyproject.toml .

# Always create files, even if no package is found. Required in builder images.
RUN poetry show psycopg2 | grep version | sed -E 's/[^0-9]*([0-9.]+).*/\1/' > /srv/wheels/psycopg2-version
RUN poetry show pillow | grep version | sed -E 's/[^0-9]*([0-9.]+).*/\1/' > /srv/wheels/pillow-version


#
# Psycopg2 builder image
#
FROM python:{{ cookiecutter.python_version }}-alpine{{ cookiecutter.alpine_version }} as psycopg2-wheel

RUN apk add --no-cache postgresql-dev
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev

WORKDIR /srv/wheels

COPY --from=versions /srv/wheels/psycopg2-version .
# If no version, do not install.
RUN if [ -s "psycopg2-version" ]; \
    then pip wheel psycopg2==$(cat psycopg2-version); \
    fi


#
# Pillow building image
#
FROM python:{{ cookiecutter.python_version }}-alpine{{ cookiecutter.alpine_version }} as pillow-wheel

RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache jpeg-dev zlib-dev

WORKDIR /srv/wheels

COPY --from=versions /srv/wheels/pillow-version .
# If no version, do not install.
RUN if [ -s "pillow-version" ]; \
    then pip wheel pillow==$(cat pillow-version); \
    fi


#
# Django image
#
FROM python:{{ cookiecutter.python_version }}-alpine{{ cookiecutter.alpine_version }} as django

RUN pip --no-cache-dir install -U poetry
RUN apk add --no-cache postgresql-libs postgresql-client libjpeg bash
WORKDIR /srv/app

RUN poetry config settings.virtualenvs.create false

COPY --from=psycopg2-wheel /srv/wheels/ /srv/wheels/
COPY --from=pillow-wheel /srv/wheels/ /srv/wheels/
RUN if ls /srv/wheels/*.whl; \
    then pip --no-cache-dir install /srv/wheels/*.whl; \
    fi

COPY poetry.lock .
COPY pyproject.toml .
RUN PIP_NO_CACHE_DIR=false poetry install

EXPOSE 8000/tcp

COPY docker/django/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-Wd", "manage.py", "runserver", "--nostatic", "0.0.0.0:8000"]
