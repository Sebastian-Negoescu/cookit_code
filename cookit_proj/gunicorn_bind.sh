#!/bin/bash
gunicorn --workers 8 --threads 4 --bind=0.0.0.0:8000 --chdir=/home/site/wwwroot cookit.wsgi
