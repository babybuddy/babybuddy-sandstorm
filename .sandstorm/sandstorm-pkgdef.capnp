@0x8a024457ccbe99ae;

using Spk = import "/sandstorm/package.capnp";

const pkgdef :Spk.PackageDefinition = (
  id = "7yu31zwuv5f0aeg0749hvtrfz92g5ccq4mf21nvmspxwjs61duwh",

  manifest = (
    appTitle = (defaultText = "Baby Buddy"),
    appVersion = 0,  # Increment this for every release.
    appMarketingVersion = (defaultText = "1.3.4"),
    actions = [
      ( nounPhrase = (defaultText = "instance"),
        command = .firstRunCommand
      )
    ],
    continueCommand = .continueCommand,
    metadata = (
      icons = (
         appGrid = (svg = embed "app-metadata/logo-128.svg"),
         grain = (svg = embed "app-metadata/logo-24.svg"),
         market = (svg = embed "app-metadata/logo-150.svg"),
         marketBig = (svg = embed "app-metadata/logo-150.svg"),
      ),
      website = "http://baby-buddy.net",
      codeUrl = "https://github.com/babybuddy/babybuddy-sandstorm",
      license = (openSource = bsd2Clause),
      categories = [productivity, other],
      author = (
        contactEmail = "wells@chrxs.net",
        pgpSignature = embed "pgp-signature",
      ),
      pgpKeyring = embed "pgp-keyring",
      description = (defaultText = embed "app-metadata/description.md"),
      shortDescription = (defaultText = "Caregiver support app"),
      screenshots = [
        (width = 657, height = 932, png = embed "app-metadata/screenshot-desktop.png"),
        (width = 646, height = 938, png = embed "app-metadata/screenshot-mobile.png"),
      ],
    ),
  ),
  sourceMap = (
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf",
                      "opt/app/babbybuddy/.env" ]
      )
    ]
  ),
  fileList = "sandstorm-files.list",
  alwaysInclude = [ "opt/app/babybuddy", "usr/lib/python3",
                    "usr/lib/python3.7" ],
  bridgeConfig = (
    viewInfo = (
      permissions = [
        (
          name = "admin",
          title = (defaultText = "admin"),
          description = (defaultText = "grants ability to administer application"),
        ),
        (
          name = "edit",
          title = (defaultText = "edit"),
          description = (defaultText = "grants ability to modify child data"),
        ),
      ],
      roles = [
        (
          title = (defaultText = "admin"),
          permissions  = [true, true],
          verbPhrase = (defaultText = "can administer the application"),
          description = (defaultText = "admins may modify application configuration"),
        ),
        (
          title = (defaultText = "editor"),
          permissions  = [false, true],
          verbPhrase = (defaultText = "can modify data in the application"),
          description = (defaultText = "editors may view and modify all child data in the application"),
        ),
      ],
    ),
    #apiPath = "/api",
    # Apps can export an API to the world.  The API is to be used primarily by Javascript
    # code and native apps, so it can't serve out regular HTML to browsers.  If a request
    # comes in to your app's API, sandstorm-http-bridge will prefix the request's path with
    # this string, if specified.
  ),
);

const firstRunCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8000", "--", "/bin/bash", "/opt/app/.sandstorm/launcher.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SANDSTORM", value = "1"),
  ]
);

const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8000", "--", "/bin/bash", "/opt/app/.sandstorm/launcher.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SANDSTORM", value = "1"),
  ]
);
