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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`DEBUT` --- Initialization of code_aster
**************************************************

The :py:class:`Starter` starts the execution by initializing the code_aster
memory manager (*Jeveux*). For this task, it parses the arguments
through the :py:class:`~code_aster.Supervis.ExecutionParameter.ExecutionParameter`
object.
By default, arguments are read from the command line. Otherwise, the arguments
can be passed to :py:func:`.init`.

Some Python objects that have to be available from :py:mod:`libaster` are
passed during the initialization to the
:py:class:`~code_aster.Supervis.ExecutionParameter.ExecutionParameter`.
"""

import aster
import aster_core
from Comportement import catalc

from ..RunManager import LogicalUnitFile
from ..Supervis import CommandSyntax, ExecutionParameter, logger
from ..Supervis.logger import setlevel
from ..Utilities import import_object

from .ExecuteCommand import ExecuteCommand


class Starter(ExecuteCommand):
    """Define the command DEBUT."""
    command_name = "DEBUT"
    params = _is_initialized = None

    @classmethod
    def init(cls, argv):
        """Initialization of class attributes."""
        cls.params = ExecutionParameter()
        cls.params.parse_args(argv)
        cls.params.catalc = catalc
        cls.params.logical_unit = LogicalUnitFile
        cls.params.syntax = CommandSyntax
        aster_core.register(cls.params)
        aster.init(0)
        cls._is_initialized = True

    def __call__(self, **keywords):
        """Run the Command.

        Arguments:
            keywords (dict): User keywords
        """
        if Starter._is_initialized:
            return
        self.init(None)
        super(Starter, self).__call__(**keywords)

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.

        Returns:
            None: The command has no result.
        """
        logger.info("Starting DEBUT...")
        syntax = CommandSyntax(self.name, self._cata)
        syntax.define(keywords)
        aster.debut(syntax)
        syntax.free()

        return None


DEBUT = Starter()

def init(*argv, **kwargs):
    """Initialize code_aster as `DEBUT` command does + command line options.

    Arguments:
        argv (list): List of command line arguments.
    """
    if Starter._is_initialized:
        return
    if 'debug' in kwargs:
        if kwargs['debug']:
            setlevel()
        del kwargs['debug']
    DEBUT.init(argv)
    DEBUT.exec_(kwargs)
