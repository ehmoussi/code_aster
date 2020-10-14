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
# aslint: disable=C4009
# C4009: in a string

"""
:py:mod:`debugging` --- Debugging utilities
*******************************************

These module defines some convenient utilities that **are not intended to
be used in production**.

Check for dependency on input datastructures
============================================

- Run testcases with `track_dependencies` enabled by adding this line
  in :file:`code_aster/Commands/operator.py`:

  .. code-block:: python

        # for debugging
        ExecuteCommand.register_hook(track_dependencies)

- Extract data from output files (replace ``resutest`` by the results
  directory):

  .. code-block:: sh

        grep -h '#27406' resutest/*.mess > data.txt

- Start a Python session within code_aster environment (for example, by running
  ``run_aster``) and show the command dependencies.

  .. code-block:: python

        from code_aster.Helpers.debugging import ChangeCommands
        modifier = ChangeCommands("__path-to__/data.txt")
        with open("__path-to__/merge.txt", "w") as fobj:
            fobj.write(modifier.deps_txt())

"""

import os
import os.path as osp
import re

from ..Cata.Language.SyntaxUtils import force_list
from ..Objects import DataStructure
from .LogicalUnit import LogicalUnitFile

SKIPPED = object()


class DataStructureFilter:
    """This object store the path to *DataStructure* objects that are
    referenced in a dump.

    Arguments:
        current (str): Name of the current result.
        dump (str): Text dump of a *DataStructure*.
    """

    def __init__(self, current, dump):
        """Initialization"""
        self._parent_context = []
        self._current = current
        self._dump = dump
        self._keep = None
        self._path = []
        self.paths = []

    def set_parent_context(self, context):
        """Set the parent context.

        If the checker is directly called on a keyword (without checking the
        command itself) the values defined upper may be required to evaluate
        blocks conditions but the parent context has not been filled.

        This parent context could be an optional argument in visit* functions.
        """
        self._parent_context.append(context)

    def visitCommand(self, step, userDict=None):
        """Visit a Command object"""
        self._parent_context.append(userDict)
        self._visitComposite(step, userDict)
        self._parent_context.pop()

    def visitMacro(self, step, userDict=None):
        """Visit a Macro object"""
        self.visitCommand(step, userDict)

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object"""
        pass

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object"""
        # debug_message2("checking factor with", userDict)
        self._visitComposite(step, userDict)

    def visitSimpleKeyword(self, step, skwValue):
        """Visit a SimpleKeyword object"""
        islist = type(skwValue) in (list, tuple)
        skwValue = force_list(skwValue)
        keep = []
        for i in skwValue:
            if (isinstance(i, DataStructure) and i.getName() != self._current
                    and i.getName() in self._dump):
                keep.append(i)
        if keep and not islist:
            keep = keep[0]
        self._keep = keep or SKIPPED

    def _visitComposite(self, step, userDict=None):
        """Visit a composite object (containing BLOC, FACT and SIMP objects)
        """
        if isinstance(userDict, dict):
            userDict = [userDict]
        # loop on occurrences filled by the user
        for userOcc in userDict:
            userOrig = userOcc.copy()
            ctxt = self._parent_context[-1] if self._parent_context else {}
            # loop on keywords provided by the user
            for key, value in userOcc.items():
                self._path.append(key)
                # NB: block conditions are evaluated with the original values
                kwd = step.getKeyword(key, userOrig, ctxt)
                if not kwd:
                    continue
                kwd.accept(self, value)
                if self._keep is not None:
                    if self._keep is not SKIPPED:
                        self.paths.append(self._path[:])
                    self._keep = None
                self._path.pop(-1)


TEMPLATE = '''

    def dependencies(self):
        """Defines the keywords containing dependencies.

        Returns:
            list[str]: List of keywords ("SIMP" or "FACT/SIMP").
        """
        return [{used}]
'''


def track_dependencies(inst, keywords):
    """Hook that tracks commands dependencies.

    Arguments:
        inst (function): the *ExecuteCommand* instance.
        keywords (dict): User keywords.
    """
    cata = inst._cata
    result = inst._result
    if not isinstance(result, DataStructure):
        return

    filename = "dump-27406.txt"
    dumpfile = LogicalUnitFile.open(filename)
    result.debugPrint(dumpfile.unit)
    dumpfile.release()
    with open(filename, "rb") as fobj:
        dump = fobj.read().decode('ascii', errors='replace')
    os.remove(filename)

    visitor = DataStructureFilter(result.getName(), dump)
    cata.accept(visitor, keywords)
    if not visitor.paths:
        return

    paths = ["/".join(path) for path in visitor.paths]
    print("#27406:", inst.command_name, " ".join(paths))


class ChangeCommands:
    """Change source files"""
    src = osp.join(os.environ["HOME"], "dev", "codeaster", "src", "code_aster")

    def __init__(self, datafile):
        self.seen = {}
        self.data = self.read_data(datafile)

    @staticmethod
    def read_data(datafile):
        """Read and merge data"""
        with open(datafile, "r") as fdata:
            lines = fdata.readlines()
        raw = [line.split()[1:] for line in lines]
        seen = {}
        for line in raw:
            if not line:
                continue
            name = line.pop(0)
            paths = set(line)
            paths.discard("reuse")
            if name in seen:
                diff = paths.difference(seen[name])
                if diff:
                    print("#27406: changed", name, "previous:", seen[name],
                          "new:", diff)
                paths.update(seen[name])
            seen[name] = sorted(list(paths))
        return seen

    def deps_txt(self):
        """Print list of dependencies for each command"""
        lines = []
        for name, paths in self.data.items():
            values = [name] + paths
            lines.append(" ".join(values))
        return os.linesep.join(sorted(lines))

    def change_commands(self):
        """Update all commands source files"""
        for name, paths in self.data.items():
            args = [repr(path) for path in paths]
            code = TEMPLATE.format(used=", ".join(args))
            self.change_one(name, paths, code)

    def change_one(self, name, paths, code):
        """Change the source file for a command"""
        filename = self.get_command(name)
        if not filename:
            print("#27406: ERROR: file not found for", name, paths)
            return

        with open(filename, "r") as fsrc:
            content = fsrc.read()
        if "def dependencies(" in content:
            print("#27406: 'dependencies' already exists in", filename)
            return

        expr = re.compile("(?:\n+)(?P<cmd>^{0}) *=".format(name.upper()), re.M)
        mat = expr.search(content)
        if not mat:
            print("#27406: WARNING: not found", filename, name.upper())
            return
        text = expr.sub(code + "\n\n" + r"\g<cmd> =", content)
        with open(filename, "w") as fsrc:
            fsrc.write(text)

    def get_command(self, name):
        """Return the filename defining the given command."""
        basename = name.lower() + ".py"
        filename = osp.join(self.src, "Commands", basename)
        if osp.exists(filename):
            return filename
        for root, _, files in os.walk(osp.join(self.src, "MacroCommands")):
            if basename in files:
                return osp.join(root, basename)
        return None
