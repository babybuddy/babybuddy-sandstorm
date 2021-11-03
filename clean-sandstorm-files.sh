#!/bin/bash
#
# Removes entries in .sandstorm/sandstorm-files.list that are already part of
# the "alwaysInclude" configuration option. This is primary done to keep the
# files list cleaner and easier to parse/update/understand.
#
# Paths with the following directories are removed from the file:
#  - opt/app/babybuddy
#  - usr/lib/python3
#  - usr/lib/python3*
#
# This script should be run from the repo root.

sed -i "/\b\(opt\/app\/babybuddy\|usr\/lib\/python3\)\b/d" .sandstorm/sandstorm-files.list
