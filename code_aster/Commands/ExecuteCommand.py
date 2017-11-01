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
This module defines the objects on which the user's Commands are based.

All Commands executors are subclasses of :class:`.ExecuteCommand`.
Commands are factories (:meth:`ExecuteCommand.run` *classmethod*) that
create an executor that is called to create a result object.

When a new command is added there are different levels of complexity:

- Commands that are automatically added just using their catalog.
  Only the commands that return no result can work with this method.
  Other commands will raise a *NotImplementedError* exception at runtime.
  Macro-commands should work without adding anything else.

  .. note:: All Commands that are not explicitly imported by
    :mod:`code_aster.Commands.__init__` are automatically created using this
    method.

- Commands where the Fortran operator is directly called. Usually it is just
  necessary to define the type of result object.
  Example: :mod:`~code_aster.Commands.defi_compor`.

- Commands where keywords are used to create the output result.
  Example: :mod:`~code_aster.Commands.defi_group`.

- Commands where several steps must be adapted. Usually, the operator directly
  calls C++ Objects to do the job.


For all features that are not yet supported, please use utilities from
the :mod:`code_aster.Utilities` functions (example:
:func:`~code_aster.Utilities.compatibility.unsupported` or
:func:`~code_aster.Utilities.compatibility.required`) to identify them.


Base classes
============
"""

import sys

import aster
from libaster import ResultNaming

from ..Cata import Commands
from ..Cata.SyntaxChecker import CheckerError, checkCommandSyntax
from ..Cata.SyntaxUtils import mixedcopy, remove_none
from ..Objects import DataStructure
from ..Supervis import CommandSyntax, logger
from ..Utilities import (command_header, command_result, command_text,
                         deprecated, import_object)


class CommandCounter(object):
    """Simple object to store the number of called Commands.

    Attributes:
        _counter (int): Number of Commands called.
    """
    # class attribute
    _counter = 0

    @classmethod
    def incr_counter(cls):
        """Increment the counter.

        Returns:
            int: Current value of the counter.
        """
        cls._counter += 1
        return cls._counter


class ExecuteCommand(object):
    """This class implements an executor of commands.

    Commands executors are defined by subclassing this class and overloading
    some of the methods. A user's Command is a factory of these classes.

    The :meth:`run` factory creates an instance of one of these classes and
    executes successively these steps:

        - :meth:`.adapt_syntax` to eventually change the user's keywords to
          adapt the syntax from an older version. Does nothing by default.

        - :meth:`.create_result` to create the *DataStructure* object.
          The default implementation only works if the operator creates no
          object.

        - :meth:`.check_syntax` to check the user's keywords conformance to
          to catalog definition.

        - :meth:`.exec_` that is the main function of the Command.
          The default implementation calls the *legacy* Fortran operator.

        - :meth:`.post_exec` that allows to execute additional code after
          the main function. Does nothing by default.
    """
    # class attributes
    command_name = command_op = None

    _cata = _op = _result = _counter = None

    def __init__(self, command_name=None, command_op=None):
        """Initialization"""
        command_name = command_name or self.command_name
        assert command_name, "'command_name' attribute/argument not defined!"
        self._cata = getattr(Commands, command_name)
        self._op = command_op or self._cata.definition['op']
        self._result = None
        self._counter = 0

    @classmethod
    def run(cls, **keywords):
        """Run the macro-command.

        Arguments:
            keywords (dict): User keywords
        """
        cmd = cls(cls.command_name, cls.command_op)
        cmd._result = None
        check_jeveux()
        if not cmd._op:
            logger.debug("ignore command {0}".format(cmd.name))
            return

        cmd._counter = CommandCounter.incr_counter()
        cmd.adapt_syntax(keywords)
        try:
            cmd.check_syntax(keywords)
        except CheckerError as exc:
            # in case of syntax error, show the syntax and raise the exception
            cmd.print_syntax(keywords)
            raise exc.original(exc.msg)
        cmd.create_result(keywords)
        cmd.print_syntax(keywords)
        cmd.exec_(keywords)
        cmd.post_exec(keywords)
        cmd.print_result()
        return cmd._result

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

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """

    def print_syntax(self, keywords):
        """Print an echo of the Command.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        printed_args = mixedcopy(keywords)
        remove_none(printed_args)
        logger.info(command_header(self._counter))
        logger.info(command_text(self.name, printed_args, self._res_syntax()))

    def print_result(self):
        """Print an echo of the result of the command."""
        if self._result:
            logger.info(command_result(self._counter, self.name,
                                       self._result.getName()))

    def _res_syntax(self):
        """Return the name of the result for the echo of the Command.

        Returns:
            str: Automatically built name.
        """
        if self._result is None:
            return ""
        return self._result.getName()
        # return "obj{:05x}".format(self._counter)

    def check_syntax(self, keywords):
        """Check the syntax passed to the command. *keywords* will contain
        default keywords after executing this method.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        logger.debug("checking syntax of {0}...".format(self.name))
        checkCommandSyntax(self._cata, keywords, add_default=True)

    def create_result(self, keywords):
        """Create the result before calling the *exec* command function
        if needed.
        The result is stored in an internal attribute and will be returned by
        *exec*.

        *The default implementation only works if the catalog type
        exactly matches one* :class:`~code_aster.Objects.DataStructure` *type*.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        sd_type = self._cata.get_type_sd_prod(**keywords)
        if not sd_type:
            type_name = ""
            result_name = ""
            self._result = None
        else:
            raise NotImplementedError("Method 'create_result' must be "
                                      "overridden for {0!r}.".format(self.name))

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        syntax = CommandSyntax(self.name, self._cata)
        syntax.define(keywords)
        # set result and type names
        if not self._result:
            type_name = ""
            result_name = ""
        else:
            type_name = self._result.getType()
            result_name = self._result.getName()
        syntax.setResult(result_name, type_name)

        self._call_oper(syntax)
        syntax.free()

    def post_exec(self, keywords):
        """Hook that allows to add post-treatments after the *exec* function.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """

    def _result_name(self):
        """Return the name of the result of the Command.

        .. todo:: Helper method to change the supervisor in legacy version.

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
            sd_name = ResultNaming.getNewResultName()
        return sd_name


def check_jeveux():
    """Check that the memory manager (Jeveux) is up."""
    if not aster.jeveux_status():
        raise RuntimeError("code_aster memory manager is not started. "
                           "No command can be executed.")


class ExecuteCommandOps(ExecuteCommand):
    """This implements an executor of commands that use an
     `opsXXX` subroutine."""

    def _call_oper(self, syntax):
        """Call fortran operator.

        Arguments:
            syntax (*CommandSyntax*): Syntax description with user keywords.
        """
        return aster.opsexe(syntax, self._op)


class ExecuteMacro(ExecuteCommand):
    """This implements an executor of *legacy* macro-commands.

    The OPS function of *legacy* macro-commands returns a return code and
    declared results through ``self.DeclareOut(...)``.

    Now the results must be directly returned by the OPS function.

    .. todo:: Associate additional results with ``CO()``.
    """

    _store = None

    def __init__(self, command_name, command_op=None):
        """Initialization"""
        super(ExecuteMacro, self).__init__(command_name)
        self._op = command_op or import_object(self._op)

    def create_result(self, keywords):
        """Macro-commands create their results in the *exec_* method.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.

        Returns:
            misc: Result of the Command, *None* if it returns no result.
        """
        outputs = self._op(self, **keywords)
        assert not isinstance(outputs, int), "OPS must now return results."
        self._result = outputs

    # create a sub-object?
    def get_cmd(self, name):
        """Return a command."""
        from .. import Commands
        return getattr(Commands, name, None)

    @deprecated(False)
    def set_icmd(self, _):
        """Does nothing, kept for compatibility."""
        return

    @deprecated(False)
    def DeclareOut(self, result, target):
        """Register a result of the macro-command."""
        pass

    @property
    @deprecated(True, help="Not yet implemented.")
    def reuse(self):
        return

    @property
    @deprecated(True, help="Not yet implemented.")
    def sd(self):
        return

    @property
    @deprecated(True, help="Use the 'logger' object instead.")
    def cr(self):
        return logger
