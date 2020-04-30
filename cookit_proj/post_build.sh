#!/bin/bash
gunicorn --bind=0.0.0.0:8000 --chdir=/home/site/wwwroot cookit.wsgi
cd /home/site/wwwroot
source /antenv/bin/activate
python3 -m pip install -r requirements.txt
echo "from django.contrib.auth.models import User; User.objects.create_superuser('$DBUSER', 'sebastian.negoescu@gmail.com', '$DBPASS')" | python3 manage.py shell
python3 manage.py makemigrations
python3 manage.py migrate --run-syncdb
