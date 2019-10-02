# Torrential Remote

Inspired by [David Hewitt](https://github.com/davidmhewitt)'s wonderfull [Torrential](https://github.com/davidmhewitt/torrential) application, Torrential Remote allows for the remote management of multiple torrent servers.

![Torrents Page](screenshots/Torrents.png "Torrents")

## TODO
- [x] Retrieve the torrents from a server
- [x] Show the torrents in a list
- [x] Dinamically update the displayed torrents
- [ ] Add server dialog and welcome page
- [ ] Build saved servers side panel
- [ ] Add torrent from file
- [ ] Add torrent from magnet link
- [ ] Remove torrent
- [ ] Torrents sorting and filtering

## Dependencies
* valac
* libgtk-3-dev
* libgranite-dev
* libunity-dev
* libsoup-2.4
* json-glib-1.0

## Building and Installation
    git clone https://github.com/popvladaurel/Torrential-Remote.git
    cd Torrential-Remote
    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install
