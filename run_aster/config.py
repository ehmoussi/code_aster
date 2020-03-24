# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

"""
:py:mod:`config` --- Configuration of the version
-------------------------------------------------

The :py:class:`Config` object gives access to the configuration parameters
of the installed version.
These parameters are usually set during the ``waf configure`` step and are
stored in a JSON file.

The configuration file is installed in
``<installation-prefix>/share/aster/config.js``.
It contains *version parameters*.

This file can be overridden by a user file : ``$HOME/.run_aster.js``.
"""

import json
import os
import os.path as osp

from .logger import logger
from .settings import AbstractParameter, Store
from .utils import ROOT

USERCFG = osp.join(os.getenv("HOME", ""), ".run_aster.js")

VERSION_PARAMS = {
    "version_tag": "str",
    "version_sha1": "str",
    "tmpdir": "str",
    "addmem": "int",
    "parallel": "bool",
    "python": "str",
    "mpirun": "str",
    "mpirun_rank": "str",
    "FC": "str",
    "FCFLAGS": "list[str]",
}


class ConfigurationStore(Store):
    """Object that stores the version settings."""

    @staticmethod
    def _new_param(name):
        """Create a Parameter of the right type."""
        return AbstractParameter.factory(VERSION_PARAMS, name)


class Config:
    """Configuration parameters.

    Arguments:
        configjs (str): File name of the configuration file.
    """

    def __init__(self, configjs):
        self._mainjs = configjs
        self._storage = ConfigurationStore()

    @property
    def storage(self):
        """dict: Attribute that holds the 'storage' property."""
        # while it is empty, try to load the config files
        if not self._storage:
            self.load()
        return self._storage

    def load(self):
        """Load the configuration file."""
        self.load_one(self._mainjs)

    def load_one(self, jsfile):
        """Load `jsfile`."""
        logger.debug(f"reading configuration file {jsfile}")
        try:
            with open(jsfile, "rb") as jsfile:
                content = json.load(jsfile)
        except FileNotFoundError:
            logger.debug("file not found")
            return
        for key, value in content.items():
            self._storage.set(key, value)

    def get(self, key, default=None):
        """Return the value of `key` parameter or `default` if it is not
        defined.

        Arguments:
            key (str): Parameter name.
            default (misc): Default value, (default is *None*).

        Returns:
            misc: Value or default value.
        """
        return self.storage.get(key, default)

CFG = Config(osp.join(ROOT, "share", "aster", "config.js"))
