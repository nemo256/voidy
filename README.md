<div align="center">

# `Voidy`

<h3>
  A custom (personal) void linux installation script.
</h3>

<!-- Badges -->
![GitHub Repo stars](https://img.shields.io/github/stars/nemo256/voidy?style=for-the-badge)
![Maintenance](https://shields.io/maintenance/yes/2022?style=for-the-badge)
![License](https://shields.io/github/license/nemo256/voidy?style=for-the-badge)

<!-- Demo image -->
![Demo](demo.gif)

</div>

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Setup ⚙️](#setup)
* [Credits 🤝](#credits)
* [License 📑](#license)

## Setup ⚙️

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

### Make the scripts executable:
```
$ chmod +x install.sh postinstall.sh
```

### Run the installation: 
```
$ ./install.sh
```

## Credits 🤝
- Credits go to the developers of [archiso](https://github.com/archlinux/archiso).

## License 📑
- Please read [voidy/LICENSE](https://github.com/nemo256/voidy/blob/master/LICENSE)
