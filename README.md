# Voidy
A custom (personal) void linux installation script.

![Demo](demo.gif)

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Setup](#setup)
* [License](#license)
* [Credits](#credits)

## Setup

### Download the project:
```
$ xbps-install -S git
$ git clone https://github.com/nemo256/voidy
$ cd voidy
```

### Create or modify the <.env> file:
```
USERNAME=             # your username (eg: foo)
PASSWORD=             # your password (eg: bar)
HOSTNAME=             # your hostname (eg: thinkpad)
SHELL=                # preferred shell (eg: /bin/zsh)
TOKEN=                # this is the github token (you can leave it empty)
DISK=                 # disk you want to install voidy on (eg: /dev/sda)
MOUNT_OPTIONS=        # disk mount options (eg: "noatime,compress=zstd,ssd,commit=120")
FS=                   # filesystem type (eg: ext4, btrfs...)
TIMEZONE=             # timezone like this <Continent/city> (eg: Europe/paris, America/chicago)
KEYMAP=               # keymap of the keyboard (eg: us, fr, es...)
REPO=                 # main voidy repo.
ARCH=                 # architecture <eg: x86_64, i686, arm...>
```

### Make the scripts executable and execute it:
```
$ chmod +x install.sh postinstall.sh
$ ./install.sh
```

## License
- Please read voidy/LICENSE.
- If you're too lazy to read, do anything you want with this project and don't forget to give credits to me, and the developers of [voidlinux](https://voidlinux.org/).

## Credits
- Credits go to the developers of [voidlinux](https://voidlinux.org/).

