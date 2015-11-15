# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import inspect

from code_aster.RunManager.Initializer import finalize
from code_aster.RunManager.Pickling import Pickler
from code_aster.Supervis.logger import logger


def saveObjects(level=1, delete=True):
    """Save objects of the caller context in a file.
    Objects are deleted from the context if delete is True."""
    caller = inspect.currentframe()
    for i in range(level):
        caller = caller.f_back
    try:
        context = caller.f_globals
        logger.debug("frame saved: {0}".format(context['__name__']))
    finally:
        del caller
    finalize()
    Pickler(context).save(delete=delete)
