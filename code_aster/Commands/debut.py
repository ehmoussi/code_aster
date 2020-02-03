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

import aster_core
import libaster

from ..Behaviours import catalc
from ..Cata.Syntax import tr
from ..Cata.SyntaxUtils import remove_none
from ..Helpers import LogicalUnitFile
from ..Messages import UTMESS, MessageLog
from ..Supervis import CommandSyntax, ExecuteCommand, Serializer, loadObjects
from ..Supervis.ctopy import checksd, print_header
from ..Supervis.TestResult import testresu_print
from ..Utilities import ExecutionParameter, Options, logger
from ..Utilities.i18n import localization

try:
    import ptvsd
    HAS_PTVSD = True
except ImportError:
    HAS_PTVSD = False


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
        cls.params.print_header = print_header
        cls.params.checksd = checksd
        cls.params.testresu_print = testresu_print
        aster_core.register(cls.params, MessageLog)
        libaster.jeveux_init()
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
    def _run_with_argv(cls, **keywords):
        """Wrapper to have the same depth calling loadObjects..."""
        cmd = cls()
        cmd._result = None
        cmd._cata.addDefaultKeywords(keywords)
        remove_none(keywords)
        cmd.exec_(keywords)

    @classmethod
    def run_with_argv(cls, **keywords):
        """Run the command with the arguments from the command line.

        Arguments:
            keywords (dict): User keywords
        """
        cls._run_with_argv(**keywords)

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        iwarn = False
        stop_with = "EXCEPTION"
        if keywords.get('CODE'):
            ExecutionParameter().enable(Options.TestMode)
            stop_with = "ABORT"
            iwarn = True

        erreur = keywords.get('ERREUR')
        if erreur:
            if erreur.get('ERREUR_F'):
                stop_with = keywords['ERREUR']['ERREUR_F']
        libaster.onFatalError(stop_with)

        debug = keywords.get('DEBUG')
        if debug:
            jxveri = debug.get('JXVERI', 'NON') == 'OUI'
            ExecutionParameter().set_option("jxveri", int(jxveri))
            if jxveri:
                UTMESS("I", "SUPERVIS_23")
            sdveri = debug.get('SDVERI', 'NON') == 'OUI'
            ExecutionParameter().set_option("sdveri", int(sdveri))
            if sdveri:
                UTMESS("I", "SUPERVIS_24")
            dbgjeveux = debug.get('JEVEUX', 'NON') == 'OUI'
            ExecutionParameter().set_option("dbgjeveux", int(dbgjeveux))
            if dbgjeveux:
                UTMESS("I", "SUPERVIS_12")
            iwarn = iwarn or jxveri or sdveri or dbgjeveux
        if iwarn:
            UTMESS('I', 'SUPERVIS_22')

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
        # 1:_call_oper, 2:ExecuteCommand.exec_, 3:Starter.exec_,
        #  4:Restarter.run, 5:ExecuteCommand.run_, 6:ExecuteCmd.run, 7:user
        # 1:_call_oper, 2:ExecuteCommand.exec_, 3:Starter.exec_,
        #  4:_run_with_argv, 5:run_with_argv, 6:init, 7:user
        loadObjects(level=7)


DEBUT = Starter.run
POURSUITE = Restarter.run


def init(*argv, **kwargs):
    """Initialize code_aster as `DEBUT`/`POURSUITE` command does + command
    line options.

    .. note:: :func:`init` automatically enables the ``--test`` option.

    Arguments:
        argv (list): List of command line arguments.
        kwargs (dict): Keywords arguments passed to 'DEBUT'/'POURSUITE'
            + 'debug' to quickly enable debugging messages.
    """
    if not ExecutionStarter.init(argv):
        return

    ExecutionParameter().enable(Options.TestMode)
    if kwargs.get('debug'):
        ExecutionParameter().enable(Options.Debug)
    kwargs.pop('debug', None)

    if kwargs.get('ptvsd') and HAS_PTVSD:
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
