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

"""
:py:mod:`export` --- Export file object
---------------------------------------

The :py:class:`Export` object parses ``.export`` files and provides
getters and setters onto the parameters.

This object contains :py:class:`File` and :py:class:`Parameter` objects.
The arguments of the code_aster command line are stored in a special
:py:class:`Parameter` object.
"""

import argparse
import os.path as osp
import platform
import re

from .config import CFG
from .logger import logger
from .utils import ROOT

DEPRECATED = "__DEPRECATED__"

PARAMS_TYPE = {
    "actions": "list[str]",
    "debug": "str",
    "expected_diag": "list[str]",
    "facmtps": "float",
    "hide-command": "bool",
    "interact": "bool",
    "memjob": "int",
    "memory_limit": "float",
    "mode": "str",
    "mpi_nbcpu": "int",
    "mpi_nbnoeud": "int",
    "nbmaxnook": "int",
    "ncpus": "int",
    "testlist": "list[str]",
    "time_limit": "float",
    "tpmax": "float",
    "tpsjob": "int",
    # command line arguments
    "args": "list[str]",
}

# deprecated for simple execution
PARAMS_TYPE.update({}.fromkeys(
    ["MASTER_memory_limit", "MASTER_time_limit", "aster_root", "consbtc",
     "cpresok", "diag_pickled", "mclient", "mem_aster", "noeud", "nomjob",
     "parent", "platform", "protocol_copyfrom", "protocol_copyto",
     "protocol_exec", "proxy_dir", "rep_trav", "origine", "server", "serveur",
     "service", "soumbtc", "studyid", "username", "uclient", "version"],
    DEPRECATED))


class Parameter:
    """A parameter defined in a Export object.

    Attributes:
        name (str): Parameter name.
        value (misc): Value of the parameter.
    """

    @staticmethod
    def factory(name):
        """Create a Parameter of the right type."""
        typ = PARAMS_TYPE.get(name)
        if typ is None:
            logger.warning(f"unknown parameter: '{name}'")
            typ = "list[str]"
        if typ == DEPRECATED:
            typ = "str"
            return None
        if typ is "str":
            klass = ParameterStr
        elif typ is "bool":
            klass = ParameterBool
        elif typ is "int":
            klass = ParameterInt
        elif typ is "float":
            klass = ParameterFloat
        elif typ == "list[str]":
            klass = ParameterListStr
        else:
            raise TypeError(typ)
        return klass(name)

    def __init__(self, name):
        self._name = name
        self._value = None

    @property
    def name(self):
        """str: Attribute that holds the 'name' property."""
        return self._name

    @property
    def value(self):
        """misc: Attribute that holds the 'value' property."""
        return self._value

    def convert(self, value):
        """Convert a value for the parameter type."""
        try:
            return self._convert(value)
        except (TypeError, ValueError) as exc:
            logger.error(f"Parameter '{self.name}': {exc}", exception=exc)

    def _convert(self, value):
        raise NotImplementedError("must be subclassed!")

    def set(self, value):
        """Convert and set the value.

        Arguments:
            value (misc): New value.
        """
        self._value = self.convert(value)

    def __repr__(self):
        """Simple representation"""
        return "P {0.name} {0.value}".format(self)


class ParameterStr(Parameter):
    """A parameter defined in a Export object of type string."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return str(value)


class ParameterBool(Parameter):
    """A parameter defined in a Export object of type boolean."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        if value == "":
            value = True
        elif value == "False":
            value = False
        return bool(value)

    def __repr__(self):
        """Simple representation"""
        return "" if not self._value else "P {0.name}".format(self)


class ParameterInt(Parameter):
    """A parameter defined in a Export object of type integer."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return int(float(value))


class ParameterFloat(Parameter):
    """A parameter defined in a Export object of type float."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return float(value)


class ParameterListStr(Parameter):
    """A parameter defined in a Export object of type list of strings."""

    def _convert(self, value):
        if not isinstance(value, (list, tuple)):
            value = [value]
        value = [str(i) for i in value]
        return value

    def __repr__(self):
        """Simple representation"""
        return "P {0.name} {1}".format(self, " ".join(self.value))


class File:
    """A file or directory defined in a Export object.

    Arguments:
        path (str): File or directory path.
        filetype (str, optional): File type ("comm", "libr", "nom", "repe"...).
        unit (int, optional): Logical unit number.
        isdir (bool, optional): *True* for a directory, *False* for a file.
            If the file or directory exists, it is automatically set.
        data (bool, optional): *True* if it is an input. If neither *data* or
            *resu* is set, *data* is automatically set to *True*.
        resu (bool, optional): *True* if it is an output.
        compr (bool, optional):*True* if it is compressed.
    """

    def __init__(self, path, filetype='libr', unit=0, isdir=False,
                 data=False, resu=False, compr=False):
        self._dir = isdir
        self.path = path
        self._typ = filetype
        self._unit = int(unit)
        self._data = data or not resu
        self._resu = resu
        self._compr = compr

    @property
    def path(self):
        """str: Attribute that holds the 'path' property."""
        return self._path

    @path.setter
    def path(self, path):
        if osp.exists(path):
            self._dir = osp.isdir(path)
        self._path = path

    @property
    def filetype(self):
        """str: Attribute that holds the 'filetype' property."""
        if self.is_tests_data:
            return "nom"
        return self._typ

    @property
    def is_tests_data(self):
        """bool: Attribute that tells if this is a data file for testcase.
        It is taken from a specific directory.
        """
        return self._typ == "tests_data"

    @property
    def unit(self):
        """int: Attribute that holds the 'unit' property."""
        return self._unit

    @property
    def compr(self):
        """bool: Attribute that holds the 'compr' property."""
        return self._compr

    @property
    def isdir(self):
        """bool: Attribute that holds the 'isdir' property."""
        return self._dir

    @property
    def data(self):
        """bool: Attribute that holds the 'data' property."""
        return self._data

    @property
    def resu(self):
        """bool: Attribute that holds the 'resu' property."""
        return self._resu

    def _astext(self):
        fields = []
        if self._dir:
            fields.append('R')
        else:
            fields.append('F')
        fields.append(self._typ)
        fields.append(self._path)
        drc = ""
        if self.data:
            drc += 'D'
        if self.resu:
            drc += 'R'
        if self.compr:
            drc += 'C'
        fields.append(drc)
        fields.append(str(self.unit))
        return fields

    @property
    def as_argument(self):
        """str: String to be passed on command_line"""
        return ":".join(self._astext())

    @classmethod
    def from_argument(cls, line):
        """Create a File object by decoding a line as formatted
        by `File.as_argument`.

        Arguments:
            line (str): Line as formatted by `File.as_argument`
        """
        typ, filetype, path, drc, unit = line.split(":")
        return cls(path, filetype, unit, typ == "R",
                   "D" in drc, "R" in drc, "C" in drc)

    def __repr__(self):
        """Simple representation"""
        return " ".join(self._astext())


class Export:
    """This object represents a `.export` file.


    Arguments:
        export_file (str, optional): File name of the export file.
        from_string (str, optional): Export content as string.
        check (bool, optional): *True* to automatically check the consistency.
            *False* if it will be run manually.
    """

    def __init__(self, filename=None, from_string=None, check=True):
        assert filename or from_string, "Export(): invalid arguments"
        if filename:
            self._filename = osp.abspath(filename)
            self._root = osp.dirname(self._filename)
            with open(filename, "r") as fobj:
                self._content = fobj.read()
        else:
            self._content = from_string
            self._filename = None
            self._root = ""
        self._params = {}
        self._pargs = ParameterListStr("args")
        self._pargs.set([])
        self._files = []
        self._checked = False
        self.parse(check)

    @property
    def filename(self):
        """str: Path to the export file or None if initialized from a text."""
        return self._filename

    @property
    def commfiles(self):
        """list[File]: List of input 'comm' File objects."""
        return [i for i in self._files if i.data if i.filetype == "comm"]

    @property
    def datafiles(self):
        """list[File]: List of input File objects (except 'comm' files)."""
        return [i for i in self._files if i.data if i.filetype != "comm"]

    @property
    def resultfiles(self):
        """list[File]: List of output File objects."""
        return [i for i in self._files if i.resu]

    def add_file(self, fileobj):
        """Add a File object.

        Arguments:
            fileobj (File): File object to be added.
        """
        self._files.append(fileobj)

    def import_file_argument(self, line):
        """Add a File object by decoding a line as formatted
        by `File.as_argument`.

        Arguments:
            line (str): Line as formatted by `File.as_argument`
        """
        self.add_file(File.from_argument(line))

    def parse(self, check):
        """Parse the export content.

        Arguments:
            check (bool): Check the consistency of the export file.
        """
        if self._checked:
            return

        comment = re.compile("^ *#")
        for line in self._content.splitlines():
            if comment.search(line) or not line.strip():
                continue
            spl = line.split()
            typ = spl.pop(0)
            assert typ in ("P", "A", "F", "R"), f"unknown type: {typ}"
            if typ == "A":
                name = spl.pop(0)
                if name != "args":
                    spl.insert(0, f"--{name}")
                self.set_argument(spl)
            elif typ == "P":
                name = spl.pop(0)
                self.set_parameter(name, spl)
            elif typ in ("F", "R"):
                filetype = spl.pop(0)
                isdir = typ == "R"
                unit = spl.pop()
                drc = spl.pop()
                path = " ".join(spl)
                entry = File(path, filetype, unit, isdir,
                             "D" in drc, "R" in drc, "C" in drc)
                self.add_file(entry)
        if check:
            self.check()

    def set_parameter(self, name, value):
        """Add a parameter.

        Arguments:
            name (str): Parameter name.
            value (misc): Parameter value.
        """
        param = self._params.setdefault(name, Parameter.factory(name))
        if not param:
            del self._params[name]
            return
        param.set(value)

    def set_argument(self, opts):
        """Add command line arguments.
        *The caller must check if the options are not already present or if they
        can appear several times.*

        Arguments:
            opts (list[str]): List of arguments (for example: "-c", "--abort",
                "--memory=1024"...).
        """
        new = []
        for i in opts:
            new.extend(str(i).split("="))
        self._pargs.set(self.args + new)

    def _abspath(self):
        """Absolutize path of *File* objects."""
        for fileobj in self._files:
            base = self._root
            # TODO to be removed as soon as run_testcases can be replaced!
            # if fileobj.is_tests_data:
            if (fileobj.is_tests_data or
                    (fileobj.filetype == "nom" and
                     not osp.exists(osp.join(base, fileobj.path)) and
                     "make_test" in self.get("actions", []))):
                base = osp.join(ROOT, "share", "aster", "tests_data")
            fileobj.path = osp.join(base, fileobj.path)

    def check(self):
        """Check consistency, fill arguments from parameter, add arguments
        that replace deprecated ones...
        """
        self._abspath()
        args = self.args
        # memory_limit in MB, --memory in MB (required), --memjeveux in Mwords
        if "--memory" not in args:
            value = None
            if "--memjeveux" in args:
                idx = args.index("--memjeveux")
                # should have a value
                if idx + 1 < len(args):
                    self.remove_args("--memjeveux", 1)
                    factor = 8 if "64" in platform.architecture()[0] else 4
                    value = float(args[idx + 1]) * factor
            elif self.has_param("memory_limit"):
                value = self.get("memory_limit")
            if value:
                if not self._checked:
                    value += CFG.get("addmem", 0.)
                self.set_argument(["--memory", value])
        # time_limit in s (required), tpsjob in min, --tpmax in s (required)
        if "--tpmax" not in args:
            value = None
            if self.has_param("tpsjob"):
                value = self.get("tpsjob") * 60
            if self.has_param("time_limit"):
                value = self.get("time_limit")
            if value:
                self.set_argument(["--tpmax", value])
                if not self.has_param("time_limit"):
                    self.set_parameter("time_limit", value)
        # ncpus/numthreads
        if "--numthreads" not in args:
            value = self.get("ncpus") # TODO or get limit from config
            if value:
                self.set_argument(["--numthreads", value])
        self._checked = True
        # TODO check resources limits here?


    def __repr__(self):
        """Return a representation of the Export object.

        Returns:
            str: Representation of the content.
        """
        txt = []
        if self._params:
            for param in self._params.values():
                txt.append(repr(param))
        if self.args:
            txt.append("A" + repr(self._pargs)[1:])
        for files in (self.commfiles, self.datafiles, self.resultfiles):
            if files:
                for entry in files:
                    txt.append(repr(entry))
        txt.append("")
        return "\n".join(txt)

    def write_to(self, filename):
        """Write the content to a file.

        Arguments:
            filename (str): Destination file.
        """
        with open(filename, "w") as fobj:
            fobj.write(repr(self))

    def has_param(self, key):
        """Tell if `key` is a known parameter.

        Arguments:
            key (str): Parameter name.

        Returns:
            bool: *True* it the parameter is defined, *False* otherwise.
        """
        return key in self._params

    def get_param(self, key):
        """Return a parameter.

        Arguments:
            key (str): Parameter name.

        Returns:
            misc: Parameter.
        """
        param = self._params.get(key)
        return param

    def get(self, key, default=None):
        """Return a parameter value.

        Arguments:
            key (str): Parameter name.
            default (misc, optional): Default value if the parameter does
                not exist.

        Returns:
            misc: Parameter value.
        """
        param = self.get_param(key)
        return (param and param.value) or default

    @property
    def args(self):
        """Return the arguments list.

        Returns:
            list[str]: List of arguments.
        """
        return self._pargs.value[:]

    def get_argument_value(self, key, typ):
        """Return the value of a command line argument.

        Arguments:
            key (str): Argument name.
            typ (str|int|float|bool): Type of expected value.
        """
        parser = argparse.ArgumentParser()
        if typ is bool:
            parser.add_argument(f"--{key}", action="store_true")
        else:
            parser.add_argument(f"--{key}", type=typ)
        try:
            args, _ = parser.parse_known_args(["main"] + self.args)
        except argparse.ArgumentError:
            return None
        return getattr(args, key)

    def remove_args(self, key, add):
        """Remove a command line argument.

        Arguments:
            key (str): Argument name.
            add (int): Number of additional argument to remove.
        """
        args = self._pargs.value
        if key not in args:
            return
        idx = args.index(key)
        del args[idx:idx + 1 + add]

    def set_time_limit(self, value):
        """Define the time limit value.

        Arguments:
            value (float): New time limit.
        """
        self.set_parameter("time_limit", value)
        self.remove_args("--tpmax", 1)
        self.check()

    def set_memory_limit(self, value):
        """Define the memory limit value.

        Arguments:
            value (float): New memory limit.
        """
        self.remove_args("--memory", 1)
        self.set_argument(["--memory", str(value)])
        self.check()
