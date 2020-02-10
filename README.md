# Baby Buddy Sandstorm App

This is the source for the [Baby Buddy](https://github.com/babybuddy/babybuddy)
app for [Sandstorm](https://sandstorm.io/).

## Caveats

- Baby Buddy currently only supports setting the application time zone from an
environment variable. This cannot be achieved with the regular Sandstorm grain
workflow, so the timezone is locked to Etc/UTC.

- Sandstorm user ID's are used for the username in Baby Buddy. This name is
used for display throughout the app and is not terribly useful.

- Baby Buddy's API has not been fully implemented with Sandbox's API
integration.

## Development

Primary development for the Baby Buddy application occurs at [Baby Buddy](https://github.com/babybuddy/babybuddy)
on GitHub. This repository is specifically for the Sandstorm app build process.

### Sandstorm configuration

The primary files for the Sandstorm app configuration are:

- [`setup.sh`](.sandstorm/setup.sh): Installs nginx, uwsgi, pipenv, sqlite3 and
git.

- [`build.sh`](.sandstorm/build.sh): Gets Baby Buddy application code from
GitHub, creates an `.env` file for the application with settings location and a
`SECRET_KEY`, checks out the version specified in [`sandstorm-pkgdef.capnp`](.sandstorm/sandstorm-pkgdef.capnp)
and establishes the virtual environment.

- [`launcher.sh`](.sandstorm/launcher.sh): Prepares system directories, runs
application migrations, and starts uwsgi and nginx.

### Updating Baby Buddy

Follow the steps below to update the version of Baby Buddy shipped with the
Sandstorm app:

1. Clone this repository.

        git clone git@github.com:babybuddy/babybuddy-sandstorm.git
    
1. Move in to the repository.

        cd babybuddy-sandstorm
    
1. Open the [`sandstorm-pkgdef.capnp`](.sandstorm/sandstorm-pkgdef.capnp) file
and set the "appMarketingVersion" directive to a new version of Baby Buddy and
increment the "appVersion" directive by one.

        editor .sandstorm/sandstorm-pkgdef.capnp
    
1. Run the Vagrant SPK dev instance.

        vagrant-spk dev
        
    *Note: Confirm that [`sandstorm.patch`](sandstorm.patch) still applies
    during this command execution and update the patch if necessary.*
    
1. Test new/modified functionality in the Sandstorm dev environment.

        browse http://local.sandstorm.io:6080
        
1. When ready, stop the development app (Ctrl-C) and pack the new APK.

        vagrant-spk pack ~/babybuddy.spk
        
### Updating [`sandstorm.patch`](sandstorm.patch)

If Sandstorm specific changes need to updated or the patch no longer applies, a
new patch will need to created:

1. Follow the steps in the Development documentation above up to the
`vagrant-spk dev` command.

1. Stop the development app (Ctrl-C).

1. Make any necessary changes to Baby Buddy in the `babybuddy` folder.

1. When finished, cd in to the `babdybuddy` folder.

        cd babybuddy
        
1. Add all files to git.

        git add --all
        
1. Create a diff of the changes and save it to [`sandstorm.patch`](sandstorm.patch)

        git diff HEAD > ../sandstorm.patch
