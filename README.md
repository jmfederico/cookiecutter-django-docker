# Docker for Django

An opinionated [Cookiecutter](https://github.com/audreyr/cookiecutter) template for
running Django in Docker.

## Features

* Uses [PostgreSQL](http://postgresql.org) as database.
* Uses [Caddy](https://caddyserver.com) as web-server (with
[Cloudflare](https://caddyserver.com/docs/tls.dns.cloudflare) plugin).
* Serves on HTTPS.
* Uses [Alpine](https://alpinelinux.org) for base docker images.
* Includes a development [mail server](http://djfarrelly.github.io/MailDev/).
* [Poetry](http://poetry.eustace.io) as package management.
* Includes example dotenv files compatible with [dotenver](https://pypi.org/project/dotenver/).
* Builds Psycopg2 and Pillow wheels for Alpine Linux.
* Auto runs migrations on Django image.
* Allows for custom SSL certificates to be used.

## How to use

Run the following commands inside you root projects directory.

```bash
# Grab cookie and generate files
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
# Create you Django project
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
