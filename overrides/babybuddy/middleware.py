from urllib.parse import unquote

from django.contrib import auth
from django.contrib.auth import load_backend
from django.contrib.auth.backends import RemoteUserBackend
from django.core.exceptions import ImproperlyConfigured


class SandstormUserMiddleware:
    """
    Middleware for handling Sandstorm user properties.

    This is mostly lifted from django.contrib.auth.middleware but the regular
    `RemoteUserMiddleware` class is not extensible enough for Sandstorm.

    See: https://docs.sandstorm.io/en/latest/developing/auth/
    """
    user_id = 'HTTP_X_SANDSTORM_USER_ID'
    user_full_name = 'HTTP_X_SANDSTORM_USERNAME'
    user_perms = 'HTTP_X_SANDSTORM_PERMISSIONS'

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # AuthenticationMiddleware is required so that request.user exists.
        if not hasattr(request, 'user'):
            raise ImproperlyConfigured(
                "The Django remote user auth middleware requires the"
                " authentication middleware to be installed.  Edit your"
                " MIDDLEWARE setting to insert"
                " 'django.contrib.auth.middleware.AuthenticationMiddleware'"
                " before the RemoteUserMiddleware class.")
        try:
            username = request.META[self.user_id]
        except KeyError:
            if request.user.is_authenticated:
                self._remove_invalid_user(request)
            return self.get_response(request)
        if request.user.is_authenticated:
            if request.user.get_username() == username:
                return self.get_response(request)
            else:
                self._remove_invalid_user(request)

        # Authenticate (and create, if necessary) a new user.
        user = auth.authenticate(request, remote_user=username)
        if user:
            user_changed = False

            # Set first and last name.
            if request.META.get(self.user_full_name):
                name = unquote(request.META.get(self.user_full_name))
                parts = name.split(' ')
                user.first_name = parts[0]
                if len(parts) > 1:
                    user.last_name = ' '.join(parts[1:])
                user_changed = True

            # Handle Sandstorm permissions
            perms = request.META[self.user_perms].split(',')
            if 'admin' in perms:
                user.is_staff = True
                user_changed = True
            if 'edit' in perms:
                user.is_superuser = True
                user_changed = True

            if user_changed:
                user.save()
            request.user = user
            auth.login(request, user)

        return self.get_response(request)

    def _remove_invalid_user(self, request):
        """
        Remove the current authenticated user in the request which is invalid
        but only if the user is authenticated via the RemoteUserBackend.
        """
        try:
            stored_backend = load_backend(request.session.get(
                auth.BACKEND_SESSION_KEY, ''))
        except ImportError:
            auth.logout(request)
        else:
            if isinstance(stored_backend, RemoteUserBackend):
                auth.logout(request)
