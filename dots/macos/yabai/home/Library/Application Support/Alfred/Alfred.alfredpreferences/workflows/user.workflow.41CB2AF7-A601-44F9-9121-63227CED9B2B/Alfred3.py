#!/usr/bin/python3
# -*- coding: utf-8 -*-
import json
import os
import sys
import time
from plistlib import dump, load

"""
Alfred Script Filter generator class
Version: 3.3
Python 3 required!
"""


class Items(object):
    """
    Alfred WF Items object to generate Script Filter object

    Returns:

        object: WF  object
    """

    def __init__(self):
        self.item = {}
        self.items = []
        self.mods = {}

    def getItemsLengths(self) -> int:
        return len(self.items)

    def setKv(self, key: str, value: str) -> None:
        """
        Set a key value pair to item

        Args:

            key (str): Name of the Key
            value (str): Value of the Key
        """
        self.item.update({key: value})

    def addItem(self) -> None:
        """
        Add/commits an item to the Script Filter Object

        Note: addItem needs to be called after setItem, addMod, setIcon
        """
        self.addModsToItem()
        self.items.append(self.item)
        self.item = {}
        self.mods = {}

    def setItem(self, **kwargs: str) -> None:
        """
        Add multiple key values to define an item

        Note: addItem needs to be called to submit a Script Filter item
        to the Script Filter object

        Args:

            kwargs (kwargs): title,subtitle,arg,valid,quicklookurl,uid,automcomplete,type
        """
        for key, value in kwargs.items():
            self.setKv(key, value)

    def getItem(self, d_type: str = "") -> str:
        """
        Get current item definition for validation

        Args:

            d_type (str, optional): defines returned object format "JSON" if it needs to be readable . Defaults to "".

        Returns:

            str: JSON represenation of an item
        """
        if d_type == "":
            return self.item
        else:
            return json.dumps(self.item, default=str, indent=4)

    def getItems(self, response_type: str = "json") -> json:
        """
        get the final items data for which represents the script filter output

        Args:

            response_type (str, optional): "dict"|"json". Defaults to "json".

        Raises:

            ValueError: If key is not "dict"|"json"

        Returns:

            str: returns the item representing script filter output
        """
        valid_keys = {"json", "dict"}
        if response_type not in valid_keys:
            raise ValueError(f"Type must be in: {valid_keys}")
        the_items = dict()
        the_items.update({"items": self.items})
        if response_type == "dict":
            return the_items
        elif response_type == "json":
            return json.dumps(the_items, default=str, indent=4)

    def setIcon(self, m_path: str, m_type: str = "") -> None:
        """
        Set the icon of an item.
        Needs to be called before addItem!

        Args:

            m_path (str): Path to the icon
            m_type (str, optional): "icon"|"fileicon". Defaults to "".
        """
        self.setKv("icon", self.__define_icon(m_path, m_type))

    def __define_icon(self, path: str, m_type: str = "") -> dict:
        """
        Private method to create icon set

        Args:

            path (str): Path to the icon file

            m_type (str, optional): "image"|"fileicon". Defaults to "".

        Returns:

            dict: icon and type
        """
        icon = {}
        if m_type != "":
            icon.update({"type": m_type})
        icon.update({"path": path})
        return icon

    def addMod(
        self,
        key: str,
        arg: str,
        subtitle: str,
        valid: bool = True,
        icon_path: str = "",
        icon_type: str = "",
    ) -> None:
        """
        Add a mod to an item

        Args:

            key (str): "alt"|"cmd"|"shift"|"fn"|"ctrl
            arg (str): Value of Mod arg
            subtitle (str): Subtitle
            valid (bool, optional): Arg valid or not. Defaults to True.
            icon_path (str, optional): Path to the icon relative to WF dir. Defaults to "".
            icon_type (str, optional): "image"|"fileicon". Defaults to "".

        Raises:

            ValueError: if key is not in list
        """
        valid_keys = {"alt", "cmd", "shift", "ctrl", "fn"}
        if key not in valid_keys:
            raise ValueError(f"Key must be in: {valid_keys}")
        mod = {}
        mod.update({"arg": arg})
        mod.update({"subtitle": subtitle})
        mod.update({"valid": valid})
        if icon_path != "":
            the_icon = self.__define_icon(icon_path, icon_type)
            mod.update({"icon": the_icon})
        self.mods.update({key: mod})

    def addModsToItem(self) -> None:
        """
        Adds mod to an item
        """
        if bool(self.mods):
            self.setKv("mods", self.mods)
        self.mods = dict()

    def updateItem(self, id: int, key: str, value: str) -> None:
        """
        Update an Alfred script filter item key with a new value

        Args:

            id (int): list indes
            key (str): key which needs to be updated
            value (str): new value
        """
        dict_item = self.items[id]
        kv = dict_item[key]
        dict_item[key] = kv + value
        self.items[id] = dict_item

    def write(self, response_type: str = "json") -> None:
        """
        Generate Script Filter Output and write back to stdout

        Args:

            response_type (str, optional): json or dict as output format. Defaults to 'json'.
        """
        output = self.getItems(response_type=response_type)
        sys.stdout.write(output)


class Tools(object):
    """
    Alfred Tools, helpful methos when dealing with Scripts in Alfred

    Args:

        object (obj): Object class
    """
    @staticmethod
    def logPyVersion() -> None:
        """
        Log Python Version to shell
        """
        Tools.log("PYTHON VERSION:", sys.version)

    @staticmethod
    def log(*message) -> None:
        """
        Log message to stderr
        """
        sys.stderr.write(f'{" ".join(message)}\n')

    @staticmethod
    def getEnv(var: str, default: str = str()) -> str:
        """
        Reads environment variable

        Args:

            var (string}: Variable name
            default (string, optional): fallback if None

        Returns:

            (str): Env value or string if not available
        """
        return os.getenv(var) if os.getenv(var) is not None else default

    @staticmethod
    def getEnvBool(var: str, default: bool = False) -> bool:
        """
        Reads boolean env variable provided as text

        Args:

            var (str): Name of the env variable
            default (bool, optional): Default if not found. Defaults to False.

        Returns:

            bool: True or False as bool
        """
        if os.getenv(var).lower() == "true":
            return True
        else:
            return default

    @staticmethod
    def getArgv(i: int, default=str()) -> str:
        """
        Get argument values from input in Alfred or empty if not available

        Args:

            i (int): index of argument
            default (string, optional): Fallback if None, default string

        Returns:

            response_type (str) -- argv string or None
        """
        try:
            return sys.argv[i]
        except IndexError:
            return default
            pass

    @staticmethod
    def getDateStr(float_time: float, format: str = "%d.%m.%Y") -> str:
        """
        Format float time to string

        Args:

            float_time (float): Time in float

            format (str, optional): format string. Defaults to '%d.%m.%Y'.

        Returns:

            str: Formatted Date String
        """
        time_struct = time.gmtime(float_time)
        return time.strftime(format, time_struct)

    @staticmethod
    def getDateEpoch(float_time: float) -> str:
        return time.strftime("%d.%m.%Y", time.gmtime(float_time / 1000))

    @staticmethod
    def sortListDict(list_dict: list, key: str, reverse: bool = True) -> list:
        """
        Sort List with Dictionary based on given key in Dict

        Args:

            list_dict (list(dict)): List which contains unsorted dictionaries

            key (str): name of the key of the dict

            reverse (bool, optional): Reverse order. Defaults to True.

        Returns:

            list(dict): sorted list of dictionaries
        """
        return sorted(list_dict, key=lambda k: k[key], reverse=reverse)

    @staticmethod
    def sortListTuple(list_tuple: list, el: int, reverse: bool = True) -> list:
        """
        Sort List with Tubles based on a given element in Tuple

        Args:

            list_tuple (list(tuble)): Sort List with Tubles based on a given element in Tuple
            el (int): which element
            reverse (bool, optional): Reverse order. Defaults to True.

        Returns:

            list(tuble) -- sorted list with tubles
        """
        return sorted(list_tuple, key=lambda tup: tup[el], reverse=reverse)

    @staticmethod
    def notify(title: str, text: str) -> None:
        """
        Send Notification to mac Notification Center

        Arguments:

            title (str): Title String
            text (str): The message
        """
        os.system(
            f"""
                  osascript -e 'display notification "{text}" with title "{title}"'
                  """
        )

    @staticmethod
    def strJoin(*args: str) -> str:
        """Joins a list of strings

        Arguments:

            *args (list): List which contains strings

        Returns:

            str: joined str
        """
        return str().join(args)

    @staticmethod
    def chop(theString: str, ext: str) -> str:
        """
        Cuts a string from the end and return the remaining

        Args:

            theString (str): The String to cut
            ext (str): String which needs to be removed

        Returns:

            str: chopped string
        """
        if theString.endswith(ext):
            return theString[: -len(ext)]
        return theString

    @staticmethod
    def getEnvironment() -> dict:
        """
        Get all environment variablse as a dict

        Returns:

            dict: Dict with env variables e.g. {"env1": "value"}
        """
        environment = os.environ
        env_dict = dict()
        for k, v in environment.iteritems():
            env_dict.update({k: v})
        return env_dict

    @staticmethod
    def getDataDir() -> str:
        data_dir = os.getenv("alfred_workflow_data")
        if not (os.path.isdir(data_dir)):
            os.mkdir(data_dir)
        return data_dir

    @staticmethod
    def getCacheDir() -> str:
        cache_dir = os.getenv("alfred_workflow_cache")
        if not(os.path.isdir(cache_dir)):
            os.mkdir(cache_dir)
        return cache_dir


class Plist:
    """
    Plist handling class

    Returns:

        object: A plist object


    """

    def __init__(self):
        # Read info.plist into a standard Python dictionary
        # self.info = readPlist("info.plist")
        with open("info.plist", "rb") as fp:
            self.info = load(fp)

    def getConfig(self) -> str:
        return self.info["variables"]

    def getVariable(self, variable: str) -> str:
        """
        Get Plist variable with name

        Args:

            variable (str): Name of the variable

        Returns:

            str: Value of variable with name

        """
        try:
            return self.info["variables"][variable]
        except KeyError:
            pass

    def setVariable(self, variable: str, value: str) -> None:
        """
        Set a Plist variable

        Args:

            variable (str): Name of Plist Variable
            value (str): Value of Plist Variable

        """
        # Set a variable
        self.info["variables"][variable] = value
        self._saveChanges()

    def deleteVariable(self, variable: str) -> None:
        """
        Delete a Plist variable with name

        Args:

            variable (str): Name of the Plist variable

        """
        try:
            del self.info["variables"][variable]
            self._saveChanges()
        except KeyError:
            pass

    def _saveChanges(self) -> None:
        """
        Save changes to Plist
        """
        # writePlist(self.info, "info.plist")
        with open("info.plist", "wb") as fp:
            dump(self.info, fp)


class Keys(object):
    CMD = u'\u2318'
    SHIFT = u'\u21E7'
    ENTER = u'\u23CE'
    ARROW_RIGHT = u'\u2192'
