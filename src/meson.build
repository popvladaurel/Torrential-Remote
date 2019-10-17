executable(
    meson.project_name(),
    'Main.vala',
    'Application.vala',

    'Main/Window.vala',
    'Main/HeaderBar.vala',
    
    'Torrent/Row.vala',
    'Torrent/Model.vala',
    'Torrent/Statuses.vala',

    'Client/Model.vala',
    'Client/View.vala',

    'Server/Item.vala',
    'Server/Model.vala',  
    'Server/Dialog.vala',
    'Server/Controller.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('unity'),
        dependency('granite'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
    ],
    install: true
)

