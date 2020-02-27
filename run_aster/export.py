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

import os.path as osp
import re

from .logger import logger


DEPRECATED = "__DEPRECATED__"

PARAMS_TYPE = {
    "actions": "list[str]",
    "debug": "str",
    "expected_diag": "list[str]",
    "facmtps": "float",
    "max_base": "float",
    "memjeveux": "float",
    "memjob": "int",
    "memory_limit": "float",
    "mpi_nbcpu": "int",
    "mpi_nbnoeud": "int",
    "nbmaxnook": "int",
    "ncpus": "int",
    "testlist": "list[str]",
    "time_limit": "float",
    "tpmax": "float",
    "tpsjob": "int",
    "version": "str",
    # deprecated for simple execution
    "consbtc": DEPRECATED,
    "cpresok": DEPRECATED,
    "diag_pickled": DEPRECATED,
    "mclient": DEPRECATED,
    "mem_aster": DEPRECATED,
    "mode": DEPRECATED,
    "noeud": DEPRECATED,
    "nomjob": DEPRECATED,
    "parent": DEPRECATED,
    "rep_trav": DEPRECATED,
    "origine": DEPRECATED,
    "serveur": DEPRECATED,
    "service": DEPRECATED,
    "soumbtc": DEPRECATED,
    "username": DEPRECATED,
    "uclient": DEPRECATED,
}

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

    def _convert(self, value):
        raise NotImplementedError("must be subclassed!")

    def set(self, value):
        """Convert and set the value.

        Arguments:
            value (misc): New value.
        """
        self._value = self._convert(value)


class ParameterStr(Parameter):
    """A parameter defined in a Export object of type string."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return str(value)


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
        self._path = path
        self._typ = filetype
        self._unit = int(unit)
        if osp.exists(path):
            isdir = osp.isdir(path)
        self._dir = isdir
        self._data = data or not resu
        self._resu = resu
        self._compr = compr

    @property
    def path(self):
        """str: Attribute that holds the 'path' property."""
        return self._path

    @property
    def filetype(self):
        """str: Attribute that holds the 'filetype' property."""
        return self._typ

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

    def __repr__(self):
        """Simple representation"""
        txt = ""
        if self._dir:
            txt += 'R '
        else:
            txt += 'F '
        txt += self.filetype + ' ' + self.path + ' '
        if self.data:
            txt += 'D'
        if self.resu:
            txt += 'R'
        if self.compr:
            txt += 'C'
        txt += ' ' +  str(self.unit)
        return txt


class Export:
    """This object represents a `.export` file.

    Arguments:
        export_file (str): File name of the export file.
    """

    def __init__(self, filename):
        self._filename = filename
        self._params = {}
        self._args = {}
        self._files = []
        self._read = False
        self.parse()

    @property
    def datafiles(self):
        """list[File]: List of input File objects."""
        return [i for i in self._files if i.data]

    @property
    def resultfiles(self):
        """list[File]: List of output File objects."""
        return [i for i in self._files if i.resu]

    def parse(self, force=False):
        """Parse the export content.

        Arguments:
            force (bool): Force reloading of the export file.
        """
        if self._read and not force:
            return

        with open(self._filename, "r") as fobj:
            content = fobj.read()
        comment = re.compile("^ *#")

        for line in content.splitlines():
            if comment.search(line) or not line.strip():
                continue
            spl = line.split()
            typ = spl.pop(0)
            assert typ in ("P", "A", "F", "R"), f"unknown type: {typ}"
            if typ in ("P", "A"):
                name = spl.pop(0)
                store = self._params if typ == "P" else self._args
                param = store.setdefault(name, Parameter.factory(name))
                if not param:
                    del store[name]
                    continue
                param.set(spl)
                store[name] = param
            elif typ in ("F", "R"):
                filetype = spl.pop(0)
                isdir = typ == "R"
                unit = spl.pop()
                drc = spl.pop()
                path = " ".join(spl)
                entry = File(path, filetype, unit, isdir,
                             "D" in drc, "R" in drc, "C" in drc)
                self._files.append(entry)
        self._read = True

    def __repr__(self):
        """Return a representation of the Export object.

        Returns:
            str: Representation of the content.
        """
        txt = []
        if self._params:
            txt.append("Parameters:")
            for param in self._params.values():
                txt.append("    {0.name}: {0.value}".format(param))
        if self._args:
            txt.append("Command line arguments:")
            for param in self._args.values():
                txt.append("    {0.name}: {0.value}".format(param))
        data = self.datafiles
        if data:
            txt.append("Data files/directories:")
            for entry in data:
                txt.append("    " + repr(entry))
        result = self.resultfiles
        if result:
            txt.append("Result files/directories:")
            for entry in result:
                txt.append("    " + repr(entry))
        return "\n".join(txt)

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

    def get(self, key):
        """Return a parameter value.

        Arguments:
            key (str): Parameter name.

        Returns:
            misc: Parameter value.
        """
        param = self.get_param(key)
        return param and param.value
