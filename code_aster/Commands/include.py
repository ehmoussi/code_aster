# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: mathieu.courtois@edf.fr

import inspect
import os.path as osp

from ..Supervis import ExecuteCommand
from ..Utilities import ExecutionParameter


AUTO_IMPORT = """
# added for compatibility with code_aster legacy
from math import *
import code_aster
from code_aster.Commands import *
"""

class Include(ExecuteCommand):
    """Command that *imports* an additional commands file."""
    command_name = "INCLUDE"

    def exec_(self, keywords):
        """Execute the file to be included in the parent context."""
        level = 3
        caller = inspect.currentframe()
        for _ in range(level):
            caller = caller.f_back
        try:
            context = caller.f_globals
        finally:
            del caller

        if keywords.get("UNITE"):
            filename = 'fort.{0}'.format(keywords["UNITE"])
        else:
            rcdir = ExecutionParameter().get_option('rcdir')
            filename = osp.join(rcdir, 'tests_data', keywords["DONNEE"])

        with open(filename) as fobj:
            exec(compile(AUTO_IMPORT + fobj.read(), filename, 'exec'), context)


INCLUDE = Include.run
