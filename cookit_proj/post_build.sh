cd /home/site/wwwroot
source /antenv/bin/activate
python3 -m pip install --upgrade -r requirements.txt
python3 manage.py makemigrations
python3 manage.py migrate
echo "from django.contrib.auth.models import User; User.objects.create_superuser('$DBUSER', 'sebastian.negoescu@gmail.com', '$DBPASS')" | python3 manage.py shell
python3 manage.py migrate --run-syncdb
python3 manage.py collectstatic