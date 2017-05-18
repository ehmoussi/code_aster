# coding: utf-8

"""
This package adds the support of macro-commands.
"""

import sys

from code_aster.Cata import Commands, checkSyntax
from code_aster.Cata.SyntaxUtils import debug_message2


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


def import_object(uri):
    """Load and return a python object (class, function...).
    Its `uri` looks like "mainpkg.subpkg.module.object", this means
    that "mainpkg.subpkg.module" is imported and "object" is
    the object to return.

    Arguments:
        uri (str): Path to the object to import.

    Returns:
        object: Imported object.
    """
    path = uri.split('.')
    modname = '.'.join(path[:-1])
    if len(modname) == 0:
        raise ImportError("invalid uri: {0}".format(uri))
    mod = obj = '?'
    objname = path[-1]
    try:
        __import__(modname)
        mod = sys.modules[modname]
    except ImportError as err:
        raise ImportError("can not import module : {0} ({1})"
                          .format(modname, str(err)))
    try:
        obj = getattr(mod, objname)
    except AttributeError as err:
        raise AttributeError("object ({0}) not found in module {1!r}. "
                             "Module content is: {2}"
                             .format(objname, modname, tuple(dir(mod))))
    return obj
