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

These *version parameters* can be overridden by a user file:
``$HOME/.run_aster.js``.

The user can override these parameters depending on the *server name* and/or the
*version* using filters. A *server* is defined by its *name*, a *version* by
its *path*.

Parameters are read from the installation directory (``config.js``), then
per-server configuration are read in the order in the list and finally,
the per-version configurations are evaluated.

Example of ``$HOME/.run_aster.js`` (for this example only ``tmpdir`` is set
in different cases):

.. code-block:: json

    {
        "server": [
            {
                "name": "*",
                "config": {
                    "tmpdir": "/tmp_for_all_servers",
                },
                "name": "eocn*",
                "config": {
                    "tmpdir": "/tmp_for_eocn_nodes",
                }
            }
        ],
        "version": [
            {
                "path": "*/install/14*",
                "config": {
                    "tmpdir": "/tmp_for_v14",
                }
            },
            {
                "path": "*/dev/codeaster/install/*",
                "config": {
                    "tmpdir": "/tmp_for_development_version",
                }
            }
        ]
    }

What is the value for ``tmpdir`` on a cluster node named ``eocn123`` running
the version installed in the ``/projets/aster/install/14.4/mpi``?

- First, ``tmpdir`` is read from
  ``/projets/aster/install/14.4/mpi/share/aster/config.js``.

- Does ``eocn123`` match ``"*"``? Yes, so use ``/tmp_for_all_servers``.

- Does ``eocn123`` match ``"eocn*"``? Yes, so use ``/tmp_for_eocn_nodes``.

- Does ``/projets/aster/install/14.4/mpi`` match ``"*/install/14*"``?
  Yes, so use ``/tmp_for_v14``.

- Does ``/projets/aster/install/14.4/mpi`` match ``"*/dev/codeaster/install/*"``?
  No.

- Finally, the working directory will be created in ``/tmp_for_v14``.

Each block ``config`` can override one or more parameter already defined in
``config.js``.

The list of the supported *version parameters* are (with their type):

.. code-block:: none

    version_tag: str        - version number
    version_sha1: str       - sha1 of the revision
    tmpdir: str             - temporary directory used for execution
    addmem: int             - memory added to the memory limit found from export
    parallel: bool          - true for a parallel version
    python: str             - Python interpreter
    mpirun: str             - mpirun command line with arguments
    mpirun_rank: str        - command line to get the mpi rank
    only-proc0: bool        - true to limit output to proc #0, false to show all
    FC: str                 - fortran compiler
    FCFLAGS: list[str]      - flags for fortran compiler

All these parameters are set during the *configure* step of the installation.

"""

import json
import os
import os.path as osp
import platform
from fnmatch import fnmatchcase

from .logger import logger
from .settings import AbstractParameter, Store
from .utils import ROOT

USERCFG = osp.join(os.getenv("HOME", ""), ".run_aster.js")

# all parameters must be set by `data/wscript`
VERSION_PARAMS = {
    "version_tag": "str",
    "version_sha1": "str",
    "tmpdir": "str",
    "addmem": "int",
    "parallel": "bool",
    "python": "str",
    "mpirun": "str",
    "mpirun_rank": "str",
    "only-proc0": "bool",
    "FC": "str",
    "FCFLAGS": "list[str]",
}


class ConfigurationStore(Store):
    """Object that stores settings for a version."""

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
        self.load_one(self._mainjs, main=True)
        self.load_one(USERCFG)

    def load_one(self, jsfile, main=False):
        """Load `jsfile`.

        Arguments:
            jsfile (str): File name of the configuration file.
            main (bool): *True* for the configuration file installed for this
                version, *False* for user configuration file.
        """
        logger.debug(f"reading configuration file {jsfile}")
        try:
            with open(jsfile, "rb") as jsfile:
                content = json.load(jsfile)
        except FileNotFoundError:
            if main:
                logger.error(f"file not found: {jsfile}")
            logger.debug(f"file not found: {jsfile}")
            return
        self.import_dict(content, with_sections=not main)

    def import_dict(self, content, with_sections):
        """Set the configuration parameters from a dict.

        Arguments:
            content (dict): JSON file content
            with_sections (bool): *True* if it contains 'server' and/or
                'version' subsections, *False* if it directly contains the
                version parameters.
        """
        if with_sections:
            params = self.filter(content, "server", "name", platform.node())
            params.update(self.filter(content, "version", "path", ROOT))
        else:
            params = content
        for key, value in params.items():
            self._storage.set(key, value)

    @staticmethod
    def filter(content, section, filter_key, filter_value):
        """Filter content by keeping sections that match the filter.

        Arguments:
            content (dict): JSON file content with optional "server" and
                "version" list.

        Returns:
            dict: Version parameters for the current server and version.
        """
        params = {}
        candidates = content.get(section, [])
        if not isinstance(candidates, list):
            candidates = [candidates]
        for cfg in candidates:
            if not isinstance(cfg, dict):
                logger.warning(f"dict expected for '{section}', not: {cfg}")
                continue
            if not fnmatchcase(filter_value, cfg.get(filter_key, "")):
                continue
            config = cfg.get("config", {})
            if not isinstance(config, dict):
                logger.warning(f"dict expected for 'config', not: {config}")
                continue
            params.update(config)
        return params

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
