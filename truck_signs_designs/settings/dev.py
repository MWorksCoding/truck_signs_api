import environ
from .base import *

env = environ.Env()
# reading env file
environ.Env.read_env()

SECRET_KEY = env("DOCKER_SECRET_KEY")
DEBUG = True

CORS_ALLOWED_ORIGINS = [
    "https://www.signsfortrucks.com",
    "https://signsfortrucks.com",
    "http://localhost:3000",
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        "NAME": env("DOCKER_DB_NAME", default="truckdb"),
        "USER": env("DOCKER_DB_USER", default="truckuser"),
        "PASSWORD": env("DOCKER_DB_PASSWORD", default="truckpassword"),
        "HOST": env("DOCKER_DB_HOST", default="db"),
        "PORT": env("DOCKER_DB_PORT", default=5432),
    }
}

STRIPE_PUBLISHABLE_KEY = env("DOCKER_STRIPE_PUBLISHABLE_KEY")
STRIPE_SECRET_KEY = env("DOCKER_STRIPE_SECRET_KEY")


EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_USE_TLS = True
EMAIL_PORT = 587
EMAIL_HOST_USER = env("DOCKER_EMAIL_HOST_USER")
EMAIL_HOST_PASSWORD = env("DOCKER_EMAIL_HOST_PASSWORD")
