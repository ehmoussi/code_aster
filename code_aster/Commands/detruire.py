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
import gc
import inspect

from ..Objects import DataStructure, Function
from ..Utilities import deprecate
from ..Supervis import ExecuteCommand


class Deleter(ExecuteCommand):
    """Command that deletes *DataStructure* instances from the calling stack."""
    command_name = "DETRUIRE"

    def adapt_syntax(self, keywords):
        """Adapt keywords.

        Arguments:
            keywords (dict): User's keywords, changed in place.
        """
        if keywords.pop("OBJET", None):
            deprecate("DETRUIRE/OBJET", case=4, level=6,
                      help="Use DETRUIRE/CONCEPT instead.")
            keywords.setdefault("CONCEPT", {"NOM": Function()})

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        to_del = []
        kwlist = keywords.get("CONCEPT", [])
        for occ in kwlist:
            for obj in occ["NOM"]:
                to_del.append(obj.getName())
        if not to_del:
            return

        # calling stack
        caller = inspect.currentframe()
        for _ in range(3):
            caller = caller.f_back
        try:
            context = caller.f_globals
        finally:
            del caller

        for name in list(context.keys()):
            if isinstance(context[name], DataStructure):
                if context[name].getName() in to_del:
                    del context[name]

        # force garbage collection
        gc.collect()


DETRUIRE = Deleter.run
