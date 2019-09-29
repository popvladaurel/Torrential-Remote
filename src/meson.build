executable(
    meson.project_name(),
    'Main.vala',
    'Application.vala',
    'Widgets/Window.vala',
    'Widgets/HeaderBar.vala',
    'Widgets/Torrents.vala',
    'Widgets/TorrentRow.vala',
    'Models/Torrent.vala',
    'Models/Server.vala',
    'Models/Client.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('unity'),
        dependency('granite'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
    ],
    install: true
)
