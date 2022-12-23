#!/usr/bin/env python3

import os
import sys

from Alfred3 import Tools


def get_duti_path() -> str:
    paths = ["/usr/local/bin/duti", "/opt/homebrew/bin/duti"]
    duti_path = None
    for p in paths:
        if os.path.isfile(p):
            duti_path = p
            break
    return duti_path


def get_appid(app):
    cmd = "osascript -e 'id of app \"" + app + "\"'"
    resp = os.popen(cmd).read().splitlines()
    resp = resp[0] if len(resp) > 0 else None
    return resp


def duti(appid, ext):
    d_path = get_duti_path()
    resp = os.system(f"{d_path} -s " + appid + " " + ext + " all")
    return True if resp == 0 else False


query = Tools.getArgv(1)
[app, ext] = query.split('=')

app_id = get_appid(app)
if app_id is not None:
    resp = duti(app_id, ext)
else:
    resp = False

if resp:
    sys.stdout.write("%s succesfully assigned to %s" % (ext, app))
else:
    sys.stdout.write("Unabled to assign %s to %s" % (ext, app))
