# -*- coding: utf-8 -*-
from django.contrib.auth.models import User
from django.core.management.commands import migrate


class Command(migrate.Command):
    help = 'Prevents creation of initial superuser in Sandstorm'

    def handle(self, *args, **kwargs):
        super(Command, self).handle(*args, **kwargs)
