#!/usr/bin/env bash
set -euo pipefail

# Initialize with empty value bye default
DATABASE_URL=${DATABASE_URL:-""}

# Wait for Postgres for Django related commands.
if [[ $@ == *"manage.py "* && ! -z "$DATABASE_HOST" && -z "$DATABASE_URL" ]]
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
    # Translations
    >&2 echo "Compiling Django translations (background job)"
    ./manage.py compilemessages &

    # Migrations
    >&2 echo "Running Django migrations (background job)"
    ./manage.py migrate --noinput &

    # PIP requirements for easy Heroku deploy
    >&2 echo "Freezing requirements (background job)"
    poetry export -f requirements.txt -o requirements.txt &
fi

exec "$@"
