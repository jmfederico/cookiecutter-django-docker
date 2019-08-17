#!/usr/bin/env bash
set -euo pipefail

if [[ $@ == *" manage.py "* ]]
then
    RETRIES=60
    >&2 echo "Waiting for Postgres"
    until PGPASSWORD=$DATABASE_PASSWORD pg_isready -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER ; do
        if [ $RETRIES -eq 0 ]; then
            >&2 echo "Exiting"
            exit
        fi
        >&2 echo "Waiting for Postgres server, $((RETRIES--)) remaining attempts"
        sleep 1
    done
fi

# Run only if django server is being run.
if [[ $@ == *"manage.py runserver"* ]]
then
    # Migrations
    >&2 echo "Running Django migrations"
    ./manage.py migrate --noinput

    # PIP requirements for easy Heroku deploy
    >&2 echo "Freezing requirements"
    pip freeze > requirements.txt
fi

exec "$@"
