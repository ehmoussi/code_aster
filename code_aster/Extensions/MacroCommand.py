# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
This module adds the support of macro-commands.
"""

import sys

from ..Cata import Commands, checkSyntax
from ..Cata.SyntaxUtils import debug_message2
from .Commands.ExecuteCommand import ExecuteCommand
from ..Utilities import deprecated, import_object


class ExecuteMacro(ExecuteCommand):
    """This implements an executor of *legacy* macro-commands."""

    def __call__(self, **keywords):
        """Run the macro-command.

        Arguments:
            keywords (dict): User keywords
        """
        self.check_jeveux()
        if not self._op:
            debug_message2("ignore command {0}".format(self.name))
            return
        debug_message2("checking syntax of {0}...".format(self.name))
        checkSyntax(self._cata, keywords)
        debug_message2("running syntax of {0}...".format(self.name))
        return self._op(self, **keywords)

    # create a sub-object?
    def get_cmd(self, name):
        """Return a command."""
        import code_aster.Commands as COMMANDS
        return getattr(COMMANDS, name, None)

    @deprecated(False)
    def set_icmd(self, _):
        """Does nothing, kept for compatibility."""
        return
