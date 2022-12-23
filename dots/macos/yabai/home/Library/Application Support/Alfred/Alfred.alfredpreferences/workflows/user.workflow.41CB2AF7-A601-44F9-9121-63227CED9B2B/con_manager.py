#!/usr/bin/python3

import os
import shutil

from Alfred3 import Tools

query = Tools.getArgv(1)
adr, switch = tuple(query.split(";"))
blueutil = shutil.which('blueutil')

if blueutil:
    if switch == "disconnected":
        Tools.log(adr)
        os.popen(f'{blueutil} --connect {adr}')
    else:
        os.popen(f'{blueutil} --disconnect {adr} --wait-disconnect {adr}')
