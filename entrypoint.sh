#!/usr/bin/env bash
set -e

echo "Waiting for PostgreSQL..."

while ! nc -z db 5432; do
  sleep 0.2
done

echo "PostgreSQL is ready"

python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

# Create superuser ONLY if it does not exist
echo "Creating superuser if not exists..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username="${DJANGO_SUPERUSER_USERNAME}").exists():
    User.objects.create_superuser(
        "${DJANGO_SUPERUSER_USERNAME}",
        "${DJANGO_SUPERUSER_EMAIL}",
        "${DJANGO_SUPERUSER_PASSWORD}"
    )
EOF

echo "Starting Gunicorn..."

exec gunicorn truck_signs_designs.wsgi:application \
    --bind 0.0.0.0:8020 \
    --workers 3
