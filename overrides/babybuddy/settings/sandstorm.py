from .base import *


# Remote User authentication
# https://docs.djangoproject.com/en/3.0/howto/auth-remote-user/

MIDDLEWARE.append('babybuddy.middleware.SandstormUserMiddleware')
AUTHENTICATION_BACKENDS = [
    'django.contrib.auth.backends.RemoteUserBackend',
]


# Database
# https://docs.djangoproject.com/en/3.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/var/sqlite3/db.sqlite3',
    }
}


# Media files (User uploaded content)
# https://docs.djangoproject.com/en/3.0/topics/files/

MEDIA_ROOT = '/var/media'
