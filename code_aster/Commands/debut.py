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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`DEBUT` --- Initialization of code_aster
**************************************************

The :py:class:`Starter` starts the execution by initializing the code_aster
memory manager (*Jeveux*). For this task, it parses the arguments through the
:py:class:`~code_aster.Utilities.ExecutionParameter.ExecutionParameter` object.
By default, arguments are read from the command line. Otherwise, the arguments
can be passed to :py:func:`.init`.

Some Python objects that have to be available from :py:mod:`libaster` are
passed during the initialization to the
:py:class:`~code_aster.Utilities.ExecutionParameter.ExecutionParameter`.
"""

# for 'ptvsd'
# aslint: disable=C4008


import ptvsd

import aster
import aster_core
import libaster
from Comportement import catalc
from Utilitai.Utmess import MessageLog

from ..Cata.Syntax import tr
from ..Cata.SyntaxUtils import remove_none
from ..Helpers import LogicalUnitFile, Serializer, loadObjects
from ..Supervis import CommandSyntax
from ..Supervis.ExecuteCommand import ExecuteCommand
from ..Utilities import ExecutionParameter, Options, logger
from ..Utilities.i18n import localization


class ExecutionStarter(object):
    """Initialize the
    :class:`~code_aster.Utilities.ExecutionParameter.ExecutionParameter` object
    for requests from the both sides Python/Fortran."""
    params = _is_initialized = None

    @classmethod
    def init(cls, argv):
        """Initialization of class attributes.

        Attributes:
            argv (list[str]): List of command line arguments.

        Returns:
            bool: *True* if the initialization has been done, *False* if the
            execution was already initialized.
        """
        if cls._is_initialized:
            return False
        cls.params = ExecutionParameter()
        cls.params.parse_args(argv)
        cls.params.catalc = catalc
        cls.params.logical_unit = LogicalUnitFile
        cls.params.syntax = CommandSyntax
        aster_core.register(cls.params)
        libaster.jeveux_init()
        if cls.params.option & Options.Abort:
            libaster.onFatalError('ABORT')
        cls._is_initialized = True
        return True


class Starter(ExecuteCommand):
    """Define the command DEBUT."""
    command_name = "DEBUT"
    restart = False

    @classmethod
    def run(cls, **keywords):
        """Run the Command.

        Arguments:
            keywords (dict): User keywords
        """
        if not ExecutionStarter.init(None):
            return

        super(Starter, cls).run(**keywords)

    @classmethod
    def run_with_argv(cls, **keywords):
        """Run the command with the arguments from the command line.

        Arguments:
            keywords (dict): User keywords
        """
        cmd = cls()
        cmd._result = None
        cmd._cata.addDefaultKeywords(keywords)
        remove_none(keywords)
        cmd.exec_(keywords)

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if keywords.get('IMPR_MACRO') == 'OUI':
            ExecutionParameter().enable(Options.ShowChildCmd)

        if keywords.get('LANG'):
            translation = localization.translation(keywords['LANG'])
            tr.set_translator(translation.gettext)

        if keywords.get('IGNORE_ALARM'):
            for idmess in keywords['IGNORE_ALARM']:
                MessageLog.disable_alarm(idmess)
        super(Starter, self).exec_(keywords)

    def _call_oper(self, syntax):
        """Call fortran operator.

        Arguments:
            syntax (*CommandSyntax*): Syntax description with user keywords.
        """
        logger.info("starting the execution...")
        libaster.call_debut(syntax)


class Restarter(Starter):
    """Define the command POURSUITE."""
    command_name = "POURSUITE"
    restart = True

    def _call_oper(self, syntax):
        """Call fortran operator.

        Arguments:
            syntax (*CommandSyntax*): Syntax description with user keywords.
        """
        if not Serializer.canRestart():
            logger.error("restart aborted!")

        logger.info("restarting from a previous execution...")
        libaster.call_poursuite(syntax)
        # 1:_call_oper, 2-3:exec_, 4:Restarter.run, 5:ExecuteCmd.run, 6:user
        # 1:_call_oper, 2-3:exec_, 4:run_with_argv, 5:init, 6:user
        loadObjects(level=6)


DEBUT = Starter.run
POURSUITE = Restarter.run


def init(*argv, **kwargs):
    """Initialize code_aster as `DEBUT`/`POURSUITE` command does + command
    line options.

    Arguments:
        argv (list): List of command line arguments.
        kwargs (dict): Keywords arguments passed to 'DEBUT'/'POURSUITE'
            + 'debug' to quickly enable debugging messages.
    """
    if not ExecutionStarter.init(argv):
        return

    if kwargs.get('debug'):
        ExecutionParameter().enable(Options.Debug)
    kwargs.pop('debug', None)

    if kwargs.get('ptvsd'):
        print('Waiting for debugger attach...'),
        ptvsd.enable_attach(address=('127.0.0.1', kwargs['ptvsd']))
        ptvsd.wait_for_attach()
        ptvsd.break_into_debugger()
        # add 10 hours for debugging
        tpmax = ExecutionParameter().get_option("tpmax")
        ExecutionParameter().set_option("tpmax", tpmax + 36000)
    kwargs.pop('ptvsd', None)

    if ExecutionStarter.params.option & Options.Continue:
        Restarter.run_with_argv(**kwargs)
    else:
        Starter.run_with_argv(**kwargs)
