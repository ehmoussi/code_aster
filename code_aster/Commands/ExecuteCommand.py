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

import aster

from ..Cata import Commands, checkSyntax
from ..Supervis import CommandSyntax, logger


class ExecuteCommand(object):
    """This implements an executor of commands."""

    def __init__(self, command_name):
        """Initialization"""
        self._cata = getattr(Commands, command_name)
        self._op = self._cata.definition['op']

    def _call_oper(self, syntax):
        """Call fortran operator.

        Arguments:
            syntax (*CommandSyntax*): Syntax description with user keywords.
        """
        return aster.oper(syntax, 0)

    @property
    def name(self):
        """Returns the command name."""
        return self._cata.name

    def __call__(self, **keywords):
        """Run the macro-command.

        Arguments:
            keywords (dict): User keywords
        """
        self.check_jeveux()
        if not self._op:
            logger.debug("ignore command {0}".format(self.name))
            return
        logger.debug("checking syntax of {0}...".format(self.name))
        checkSyntax(self._cata, keywords)
        logger.debug("running syntax of {0}...".format(self.name))
        return self.exec_(**keywords)

    def exec_(self, **keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.

        Returns:
            misc: Result of the Command, *None* if it returns no result.
        """
        logger.debug("Starting {0}...".format(self.name))
        syntax = CommandSyntax(self.name, self._cata)
        syntax.define(keywords)

        # set result and type names
        sd_type = self._cata.get_type_sd_prod(**keywords)
        if not sd_type:
            type_name = ""
            result_name = ""
            result = None
        else:
            type_name = sd_type.getType()
            result_name = self._result_name()
            result = sd_type()
            result.setName(result_name)
        syntax.setResult(result_name, type_name)

        self._call_oper(syntax)
        syntax.free()
        return result

    def _result_name(self):
        """Return the name of the result of the Command.

        Returns:
            str: Name of the result returned by the Command.
        """
        from functools import partial
        from Noyau.nommage import GetNomConceptResultat as get_name
        # use *legacy* naming system that reads the command file
        get_name.use_naming_function(partial(get_name.native, level=5))
        sd_name = get_name(self.name)
        if not sd_name:
            # use an automatic naming
            sd_name = CommandSyntax.getNewResultObjectName()
        return sd_name

    def check_jeveux(self):
        """Check that the memory manager (Jeveux) is up."""
        print "DEBUG: aster.jeveux_status", aster.jeveux_status()
        if not aster.jeveux_status():
            raise RuntimeError("code_aster memory manager is not started. "
                               "No command can be executed.")


class ExecuteCommandOps(ExecuteCommand):
    """This implements an executor of commands that use an
     `opsXXX` subroutine."""

    def __init__(self, command_name, ops):
        """Initialization"""
        super(ExecuteCommandOps, self).__init__(command_name)
        self._op = ops

    def _call_oper(self, syntax):
        """Call fortran operator.

        Arguments:
            syntax (*CommandSyntax*): Syntax description with user keywords.
        """
        return aster.opsexe(syntax, self._op)
