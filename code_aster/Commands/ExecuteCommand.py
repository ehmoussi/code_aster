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
from libaster import ResultNaming

from ..Cata import Commands, checkSyntax
from ..Objects import DataStructure
from ..Supervis import cata2datastructure, CommandSyntax, logger
from ..Utilities import deprecated, import_object


class ExecuteCommand(object):
    """This class implements an executor of commands.

    Commands are defined by subclassing this class and overloading some
    of the methods.
    The *__call__* method executes successively these methods:

        - :meth:`.adapt_syntax` to eventually change the user's keywords to
          adapt the syntax from an older version. Does nothing by default.

        - :meth:`.check_syntax` to check the user's keywords conformance to
          to catalog definition.

        - :meth:`.create_result` to create the *DataStructure* object.
          The default implementation can only work if the catalog type
          exactly matches one :class:`~code_aster.Objects.DataStructure`
          type.

        - :meth:`.exec_` that is the main function of the Command.
          The default implementation calls the *legacy* Fortran operator.

        - :meth:`.post_exec` that allows to execute additional code after
          the main function. Does nothing by default.
    """
    command_name = result = None

    def __init__(self, command_name=None):
        """Initialization"""
        self._cata = getattr(Commands, command_name or self.command_name)
        self._op = self._cata.definition['op']
        self._result = None

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
        check_jeveux()
        if not self._op:
            logger.debug("ignore command {0}".format(self.name))
            return

        self.adapt_syntax(keywords)
        self.check_syntax(keywords)
        logger.debug("Starting {0}...".format(self.name))
        self.create_result(keywords)
        self.exec_(keywords)
        self.post_exec(keywords)
        return self._result

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """

    def check_syntax(self, keywords):
        """Check the syntax passed to the command. *keywords* will contain
        default keywords after executing this method.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        logger.debug("checking syntax of {0}...".format(self.name))
        checkSyntax(self._cata, keywords, add_default=True)

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
            type_name = sd_type.getType()
            klass = cata2datastructure.objtype(type_name)
            assert klass, "Object unknown for {0}".format(type_name)
            self._result = klass.create()

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


class ExecuteMacro(ExecuteCommand):
    """This implements an executor of *legacy* macro-commands.

    The OPS function of *legacy* macro-commands returns a return code and
    declared results through ``self.DeclareOut(...)``.

    Now the results must be directly returned by the OPS function.

    TODO: Associate additional results with ``CO()``.
    """

    sd = _store = None

    def __init__(self, command_name):
        """Initialization"""
        super(ExecuteMacro, self).__init__(command_name)
        self._op = import_object(self._op)

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.

        Returns:
            misc: Result of the Command, *None* if it returns no result.
        """
        logger.debug("Starting {0}...".format(self.name))
        outputs = self._op(self, **keywords)
        assert not isinstance(outputs, int), "OPS must now return results."
        return outputs

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
