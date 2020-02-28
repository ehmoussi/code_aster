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

import json
import os
import os.path as osp

from .logger import logger
from .utils import ROOT

DEFAULT_CONFIG = {
    "python": "python3",
    "tmpdir": "/tmp",
}
USERCFG = osp.join(os.getenv("HOME", ""), ".run_aster.js")


class Config:
    """Configuration parameters.

    Arguments:
        configjs (str): File name of the configuration file.
    """

    def __init__(self, configjs):
        self._cfg = DEFAULT_CONFIG.copy()
        for cfg in (configjs, USERCFG):
            logger.debug(f"reading configuration file {cfg}")
            try:
                with open(cfg, "rb") as jsfile:
                    self._cfg.update(json.load(jsfile))
            except FileNotFoundError:
                logger.debug("file not found")

    def get(self, key, default=None):
        """Return the value of `key` parameter or `default` if it is not
        defined.

        Arguments:
            key (str): Parameter name.
            default (misc): Default value, (default is *None*).

        Returns:
            misc: Value or default value.
        """
        return self._cfg.get(key, default)


CFG = Config(osp.join(ROOT, "share", "aster", "config.js"))
