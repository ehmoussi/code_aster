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
# aslint: disable=C4007,C4009
# C4007: INCLUDE() is also discouraged
# C4009: in a string, imported here

import inspect
import os.path as osp

from ..Messages import UTMESS
from ..Supervis import ExecuteCommand
from ..Utilities import ExecutionParameter, Options


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

        if keywords.get("ALARME", "OUI"):
            UTMESS('A', 'SUPERVIS_25', valk=("AsterStudy", "import"))
        if keywords.get("UNITE"):
            filename = 'fort.{0}'.format(keywords["UNITE"])
        else:
            rcdir = ExecutionParameter().get_option('rcdir')
            filename = osp.join(rcdir, 'tests_data', keywords["DONNEE"])

        option = ExecutionParameter().option
        show = (keywords.get("INFO", 0) >= 2 and
                not option & Options.ShowChildCmd)
        if show:
            ExecutionParameter().enable(Options.ShowChildCmd)
        try:
            with open(filename) as fobj:
                exec(compile(AUTO_IMPORT + fobj.read(), filename, 'exec'), context)
        except Exception as exc:
            UTMESS('F', 'FICHIER_2', valk=(filename, str(exc)))
        finally:
            if show:
                ExecutionParameter().disable(Options.ShowChildCmd)

INCLUDE = Include.run
