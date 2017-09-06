# coding: utf-8

"""
This module adds the support of macro-commands.
"""

import sys

from ..Cata import Commands, checkSyntax
from ..Cata.SyntaxUtils import debug_message2
from ..Utilities import import_object


class ExecuteMacro(object):
    """This implements an executor of *legacy* macro-commands."""

    def __init__(self, command_name):
        """Initialization"""
        self._cata = getattr(Commands, command_name)
        self._ops = import_object(self._cata.definition['op'])

    @property
    def name(self):
        """Returns the command name."""
        return self._cata.name

    def __call__(self, **keywords):
        """Run the macro-command.

        Arguments:
            keywords (dict): User keywords
        """
        if not self._ops:
            debug_message2("ignore command {0}".format(self.name))
            return
        debug_message2("checking syntax of {0}...".format(self.name))
        checkSyntax(self._cata, keywords)
        debug_message2("running syntax of {0}...".format(self.name))
        return self._ops(self, **keywords)

    # create a sub-object?
    def get_cmd(self, name):
        """Return a command."""
        import code_aster.Commands as COMMANDS
        return getattr(COMMANDS, name, None)

    def set_icmd(self, _):
        """Does nothing, kept for compatibility."""
        return
