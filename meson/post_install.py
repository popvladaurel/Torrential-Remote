#!/usr/bin/env python3

import os
import subprocess

install_prefix = os.environ['MESON_INSTALL_PREFIX']
schemadir = os.path.join(install_prefix, 'share/glib-2.0/schemas')
desktop_database_dir = os.path.join(install_prefix, 'applications')

if not os.environ.get('DESTDIR'):
    print('Compiling the gsettings schemas...')
    subprocess.call(['glib-compile-schemas', schemadir])
    print('Updating desktop database...')
    subprocess.call(['update-desktop-database', '-q', desktop_database_dir])
    print('Done!')
