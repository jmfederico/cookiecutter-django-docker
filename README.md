# Docker for Django Cookiecutter

An opinionated [Cookiecutter](https://github.com/audreyr/cookiecutter) template for
running Django in Docker. Optimized for [Cookiecutter Django](https://github.com/jmfederico/cookiecutter-django).

## Features

* Uses [PostgreSQL](https://postgresql.org) as database.
* Uses [Caddy](https://caddyserver.com) as web-server (optionally with
[Cloudflare](https://caddyserver.com/docs/tls.dns.cloudflare) plugin).
* Serves on HTTPS.
* Uses [Alpine](https://alpinelinux.org) as base docker image (except for the Django one).
* [Poetry](https://poetry.eustace.io) as package manager.
* Includes a development [mail server](https://danfarrelly.nyc/MailDev/).
* Includes example dotenv files compatible with [dotenver](https://pypi.org/project/dotenver/).
* Auto runs migrations on Django image.
* Allows for custom SSL certificates to be used.

## How to use

If you are not using the recommended [Cookiecutter Django](https://github.com/jmfederico/cookiecutter-django)
template, use the following instructions as a guide on how to use this cookiecutter.

Run the following commands inside you root projects directory.

```bash
# Bake cookie!
cookiecutter gh:jmfederico/cookiecutter-django-docker
```

```bash
# Automatically generate dotenv files
docker run --rm -v "`pwd`:/var/lib/dotenver/" jmfederico/dotenver
```

```bash
# Initialize poetry project
poetry init
poetry add django
poetry add psycopg2
```

```bash
# Create your Django project
poetry run django-admin startproject MY-PROJECT .
```

>  Now is a good idea to modify your `settings.py` file to use environmental variables:
>
>  ```python
>  SECRET_KEY = os.environ["SECRET_KEY"]
>
>  EMAIL_HOST = os.environ["EMAIL_HOST"]
>  EMAIL_PORT = os.environ["EMAIL_PORT"]
>
>  DATABASES = {
>      "default": {
>          "ENGINE": "django.db.backends.postgresql",
>          "NAME": os.environ["DATABASE_NAME"],
>          "USER": os.environ["DATABASE_USER"],
>          "PASSWORD": os.environ["DATABASE_PASSWORD"],
>          "HOST": os.environ["DATABASE_HOST"],
>          "PORT": os.environ["DATABASE_PORT"],
>      }
>  }
>  ```

```bash
# Build and run Docker images
docker-compose build
docker-compose up -d
```

Now you can visit https://localhost/

### Not using Webpack?

If you are not using Webpack you should delete the Webpack container
from the `docker-compose.yml` file.

## Running commands

The recommended way to run commands is inside the Django container:
```bash
# Create Django migrations
docker-compose run --rm django ./manage.py makemigrations
````
