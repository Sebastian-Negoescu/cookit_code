"""
WSGI config for cookit_proj project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.0/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

# os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'cookit_proj.settings')

if os.environ.get('DJANGO_ENV') == 'production':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'cookit.production')
elif os.environ.get('DJANGO_ENV') == 'dev':
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'cookit.dev')
else:
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'cookit.settings')


application = get_wsgi_application()
