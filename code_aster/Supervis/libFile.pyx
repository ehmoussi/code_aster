# coding: utf-8

# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import tempfile
from itertools import ifilter

from .libCommandSyntax import _F, getCurrentCommand, setCurrentCommand
from .logger import logger


RESERVED_UNIT = (6, 8, 9)

class FileType(object):
    """Enumeration for file type."""
    Ascii = 0
    Binary = 1
    Free = 2

    @staticmethod
    def name(value):
        """Return type as string."""
        return {
            0: "ASCII",
            1: "BINARY",
            2: "LIBRE",
        }[value]


class FileAccess(object):
    """Enumeration for file access."""
    New = 0
    Append = 1
    Old = 2

    @staticmethod
    def name(value):
        """Return type as string."""
        return {
            0: "NEW",
            1: "APPEND",
            2: "OLD",
        }[value]


class Action(object):
    """Enumeration for action."""
    Open = 0
    Register = 1
    Close = 2

    @staticmethod
    def name(value):
        """Return type as string."""
        return {
            0: "ASSOCIER",
            1: "RESERVER",
            2: "LIBERER",
        }[value]


class LogicalUnitFile(object):
    """This class defines a file associated to a fortran logical unit"""

    _free_number = range(19, 100)
    # keep in memory: {unit_number: LogicalUnitFile objects}
    _used_unit = {}

    def __init__(self, unit, filename, action, typ, access):
        self._logicalUnit = unit
        self._filename = filename
        self._register(self)
        self.register(self._logicalUnit, filename, action, typ, access)

    def __del__( self ):
        """Destructor: call DEFI_FICHIER to release the logical unit."""
        self.register(self.unit, self.filename, Action.Close)
        self._free_number.append(self.unit)

    @classmethod
    def open(cls, filename, typ=FileType.Ascii, access=FileAccess.New):
        """Open a *LogicalUnitFile* by name to be available in fortran.

        Arguments:
            filename (str): Path of the file.
            typ (FileType): Type of the file.
            access (FileAccess): Type of access.

        Returns:
            LogicalUnitFile: New logical unit.
        """
        unit = cls._get_free_number()
        return cls(unit, filename, Action.Open, typ, access)

    @classmethod
    def new_free(cls, filename):
        """Factory that returns a new free *LogicalUnitFile* for the given name.

        Arguments:
            filename (str): Path of the file. If empty, it will be automatically
                named using the unit number.

        Returns:
            LogicalUnitFile: New logical unit.
        """
        unit = cls._get_free_number()
        return cls(unit, filename, Action.Register)

    @staticmethod
    def register(unit, filename, action,
                 typ=FileType.Ascii, access=FileAccess.New):
        """Register a logical unit to the fortran manager.

        Arguments:
            unit (int): Logical unit number.
            filename (str): Path of the file. *None* or empty means to be named
                automatically 'fort.<unit>'.
            action (Action): Type of action for registering.
            typ (FileType): Type of the file.
            access (FileAccess): Type of access.
        """
        kwargs = _F(ACTION=Action.name(action),
                    UNITE=unit)
        if action == Action.Open:
            if filename:
                kwargs['FICHIER'] = filename
            kwargs['TYPE'] = FileType.name(typ)
            kwargs['ACCES'] = FileAccess.name(access)
            if typ != FileType.Ascii and access == FileAccess.Append:
                raise ValueError("'Append' access is only valid with "
                                 "type 'Ascii'.")

        previous = getCurrentCommand()
        setCurrentCommand(None)
        syntax = CommandSyntax("DEFI_FICHIER")
        syntax.define(kwargs)
        cdef INTEGER numOp = 26
        libaster.opsexe_(&numOp)
        syntax.free()
        setCurrentCommand(previous)

    @property
    def unit(self):
        """Attributes that holds the logical unit associated to this file"""
        return self._logicalUnit

    @property
    def filename(self):
        """Attributes that holds the file name"""
        return self._filename

    @classmethod
    def filename_from_unit(cls, unit):
        """Return the filename associated to a unit number.

        Arguments:
            unit (int): Number of a logical unit.

        Returns:
            str: Filename of the logical unit or 'fort.<unit>' if unknown.
        """
        logicalUnit = cls.from_number(unit)
        return logicalUnit.filename if logicalUnit else "fort.{0}".format(unit)

    @classmethod
    def from_name(cls, filename):
        """Return the logical unit associated to a unit number.

        Arguments:
            filename (str): Filename to search in the registered files.

        Returns:
            LogicalUnitFile: Object corresponding to the given filename. *None*
                otherwise.
        """
        def _predicate(item):
            return item[1].filename == filename

        try:
            unit = ifilter(_predicate, cls._used_unit.items())[0]
        except StopIteration:
            unit = -1
        return cls.from_number(unit)

    @classmethod
    def from_number(cls, unit):
        """Return the logical unit associated to a unit number.

        Arguments:
            unit (int): Number of a logical unit.

        Returns:
            LogicalUnitFile: Registered objects for this number. *None*
                otherwise.
        """
        return cls._used_unit.get(unit)

    @classmethod
    def _register(cls, logicalUnit):
        """Register a logical unit."""
        logger.debug("libFile: register unit {0}".format(logicalUnit.unit))
        cls._used_unit[logicalUnit.unit] = logicalUnit

    @classmethod
    def release_from_number(cls, unit):
        """Release a logical unit from its number.

        Arguments:
            unit (int): Number of logical unit to release.
        """
        logger.debug("libFile: release unit {0}".format(unit))
        try:
            del cls._used_unit[unit]
        except KeyError:
            msg = "Unable to free the logical unit {}".format(unit)
            raise KeyError(msg)

    @classmethod
    def release_from_name(cls, filename):
        """Release a logical unit by file name.

        Arguments:
            filename (str): Filename of the logical unit to release.
        """
        logicalUnit = cls.from_name(filename)
        if not logicalUnit:
            msg = "file {!r} not associated".format(filename)
            raise KeyError(msg)
        cls.release_from_number(logicalUnit)

    @classmethod
    def _get_free_number(cls):
        """Return the next free unit."""
        if not cls._free_number:
            raise ValueError("No more free logical unit")
        return cls._free_number.pop()


class ReservedUnitUsed(object):
    """Context manager for usage of reserved logical units.

    These units are released when entering the context and register again
    on exit.

    Arguments:
        units (int, [int...]): One or more unit to manage.
    """

    def __init__(self, *units):
        self._units = [i for i in units if i in RESERVED_UNIT]

    def __enter__(self):
        for unit in self._units:
            LogicalUnitFile.register(unit, None, Action.Close)

    def __exit__(self, exc_type, exc_value, traceback):
        for unit in self._units:
            LogicalUnitFile.register(unit, None, Action.Open,
                                     FileType.Ascii, FileAccess.Append)


cdef public void openLogicalUnitFile(const char* name, const int type,
                                     const int access ):
    LogicalUnitFile.open(name, type, access)

cdef public void releaseLogicalUnitFile(const char* name):
    LogicalUnitFile.release_from_name(name)

cdef public int getNumberOfLogicalUnitFile(const char* name):
    pyName = <bytes> name
    logicalUnit = LogicalUnitFile.from_name(pyName)
    return logicalUnit.unit

cdef public string getTemporaryFileName(const char* dir):
    dirPython = <bytes> dir
    cdef string tmpfile = tempfile.NamedTemporaryFile(dir=dirPython).name
    return tmpfile
