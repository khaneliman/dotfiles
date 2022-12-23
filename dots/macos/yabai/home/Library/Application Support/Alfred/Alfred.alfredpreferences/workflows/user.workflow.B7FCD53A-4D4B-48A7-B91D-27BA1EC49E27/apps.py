#!/usr/bin/en python3

import os
import sys

import Alfred3 as Alfred

APP_FOLDER = "/Applications"


def get_app_icon(app):
    """
    Gets file icon of an app even if the app is one level deeper

    Args:

        app (str): App name without .app


    Returns:

        str: Absolute Path string

    """
    app_file = os.path.join(APP_FOLDER, f"{app}.app")
    if os.path.exists(app_file):
        return app_file
    else:
        for root, dirs, files in os.walk(APP_FOLDER):
            for dir in dirs:
                fi = os.listdir(os.path.join(APP_FOLDER, dir))
                for f in fi:
                    if app in f:
                        return os.path.join(APP_FOLDER, dir, f)


def app_list(q):
    """ Generates as sorted list of App Names in /Applications folder.
    The function also covers 1 level in case app is on second level in App folder

    Arguments:
        q {string} -- Search String

    Returns:
        list -- Sorted list of App Names in /Applications
    """
    file_list = os.listdir(APP_FOLDER)

    for i in file_list:
        p = os.path.join(APP_FOLDER, i)
        if not(p.endswith(".app")) and os.path.isdir(p):
            deep_apps = os.listdir(os.path.join(APP_FOLDER, p))
            for da in deep_apps:
                if da.endswith('.app'):
                    file_list.append(da)

    sorted_file_list = sorted([os.path.splitext(a)[0] for a in file_list if a.endswith('.app')])
    if q != str():
        sorted_file_list = [n for n in sorted_file_list if n.lower().startswith(q.lower())]
    return sorted_file_list


query = Alfred.Tools.getArgv(1)
wf = Alfred.Items()
for app in app_list(query):
    ax = get_app_icon(app)
    wf.setItem(
        title=app,
        subtitle=f"Continue to assign {app}?",
        arg=app
    )
    wf.setIcon(ax, 'fileicon')
    wf.addItem()
if not app_list(query):
    wf.setItem(
        title="Nothing Found!",
        subtitle=f'No App found beginning with: "{query}"',
        valid=False
    )
    wf.addItem()
wf.write()
