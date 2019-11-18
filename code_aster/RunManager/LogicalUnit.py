# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

"""
:py:mod:`LogicalUnit` --- Files manipulations
*********************************************

The :py:class:`LogicalUnitFile` helps to open/close files from Fortran, C++ or
Python without conflict.

A convenient context manager :py:class:`ReservedUnitUsed` allows to
automatically open/close reserved units in case of writing in a such unit in
a Python command.

.. note:: It may be interesting to refactor that in C++ to simplify the
    interface.

"""

import tempfile


from ..Cata.Syntax import _F
from ..Supervis.logger import logger

# Units 6 and 9 can not be released/associated.
RESERVED_UNIT = (8, )

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

    @staticmethod
    def value(name):
        """Return type as string."""
        return {
            "ASCII": 0,
            "BINARY": 1,
            "LIBRE": 2,
        }[name]


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

    @staticmethod
    def value(name):
        """Return type as string."""
        return {
            "NEW": 0,
            "APPEND": 1,
            "OLD": 2,
        }[name]


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

    @staticmethod
    def value(name):
        """Return type as string."""
        return {
            "ASSOCIER": 0,
            "RESERVER": 1,
            "LIBERER": 2,
        }[name]


class LogicalUnitFile(object):
    """This class defines a file associated to a fortran logical unit"""

    _free_number = list(range(19, 100))
    # keep in memory: {unit_number: LogicalUnitFile objects}
    _used_unit = {}

    def __init__(self, unit, filename, action, typ, access,
                 to_register = True):
        self._logicalUnit = unit
        self._filename = filename
        self._register(self)
        if to_register:
            self.register(self._logicalUnit, filename, action, typ, access)

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
        return cls(unit, filename, Action.Open, FileType.Ascii,
                   FileAccess.New)

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

        from ..Commands import DEFI_FICHIER
        DEFI_FICHIER(**kwargs)

    @property
    def unit(self):
        """Attributes that holds the logical unit associated to this file"""
        return self._logicalUnit

    @property
    def filename(self):
        """Attributes that holds the file name"""
        return self._filename

    def release(self):
        """Close and free a logical unit."""
        LogicalUnitFile.register(self.unit, self.filename, Action.Close)

    @classmethod
    def filename_from_unit(cls, unit):
        """Return the filename associated to a unit number.

        Arguments:
            unit (int): Number of a logical unit.

        Returns:
            str: Filename of the logical unit or 'fort.<unit>' if unknown or
            *None* if unit=6.
        """
        logicalUnit = cls.from_number(unit)
        if unit == 6:
            return None
        if logicalUnit and logicalUnit.filename:
            filename = logicalUnit.filename
        else:
            filename = "fort.{0}".format(unit)
        return filename

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
        logger.debug("LogicalUnit: register unit {0}, name {1!r}"
                     .format(logicalUnit.unit, logicalUnit.filename))
        cls._used_unit[logicalUnit.unit] = logicalUnit

    @classmethod
    def release_from_number(cls, unit, to_register = True):
        """Release a logical unit from its number.

        Arguments:
            unit (int): Number of logical unit to release.
            to_register (bool): Boolean to avoid calling of register.
        """
        logger.debug("LogicalUnit: release unit {0}".format(unit))
        logicalUnit = cls.from_number(unit)
        if not logicalUnit:
            # RESERVED_UNIT or not registered
            return

        if to_register:
            cls.register(unit, logicalUnit.filename, Action.Close)
        if unit in cls._used_unit:
            if unit not in RESERVED_UNIT:
                cls._free_number.append(unit)
            del cls._used_unit[unit]

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
