#!/usr/bin/env python3
import os

import Alfred3 as Alfred


def get_assigned_app(ext):
    d_path = get_duti_path()
    resp = os.popen(f"{d_path} -x " + ext).read().splitlines()
    return resp


def get_duti_path() -> str:
    paths = ["/usr/local/bin/duti", "/opt/homebrew/bin/duti"]
    duti_path = None
    for p in paths:
        if os.path.isfile(p):
            duti_path = p
            break
    return duti_path


ext = Alfred.Tools.getArgv(1)
if not ext.startswith('.'):
    ext = '.' + ext

assigned_app = get_assigned_app(ext)
wf = Alfred.Items()
duti_path = get_duti_path()
if not assigned_app and duti_path:
    wf.setItem(
        title=f'{ext} is not assigned to an App',
        subtitle="Continue?",
        arg=ext
    )
    wf.setIcon('proceed.png', 'icon')
    wf.addItem()
    wf.setItem(
        title='Don\'t Continue?',
        arg='QUIT'
    )
    wf.setIcon('stop.png', 'icon')
    wf.addItem()
elif duti_path:
    wf.setItem(
        title=f'\"{ext}\" is assigned to \"{assigned_app[0]}\"',
        subtitle='Continue?',
        arg=ext
    )
    wf.setIcon('proceed.png', 'icon')
    wf.addItem()
    wf.setItem(
        title='Don\'t Continue?',
        arg='QUIT'
    )
    wf.setIcon('stop.png', 'icon')
    wf.addItem()
else:
    wf.setItem(
        title="Duti was not installed!",
        subtitle="Install Duti first: \"brew install duti\"",
        valid=False
    )
    wf.addItem()

wf.write()
