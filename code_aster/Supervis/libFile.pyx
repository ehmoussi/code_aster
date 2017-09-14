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

from code_aster.Supervis.libCommandSyntax import getCurrentCommand, setCurrentCommand
from code_aster.Supervis.libCommandSyntax import _F


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


class LogicalUnitFile(object):
    """This class defines a file associated to a fortran logical unit"""

    _free_number = range(19, 100)
    _used_unit = {}

    def __init__( self, name, typ=FileType.Ascii, access=FileAccess.New ):
        """
        The constructor currently calls DEFI_FICHIER to reserve a logical unit
        @param filename Path to the file
        @param typ Type of file (Ascii, Binary, Free)
        @param access Type of access (New, Append, Old)
        """
        self._logicalUnit = self._get_free_number()
        self._filename = name or 'fort.{}'.format(name)
        self._register(self)

        previous = getCurrentCommand()
        setCurrentCommand( None )
        syntax = CommandSyntax( "DEFI_FICHIER" )
        syntax.define( _F( ACTION="ASSOCIER",
                           UNITE=self._logicalUnit,
                           FICHIER=self._filename,
                           TYPE=FileType.name(typ),
                           ACCES=FileAccess.name(access),
                         )
                     )
        cdef INTEGER numOp = 26
        libaster.opsexe_( &numOp )
        syntax.free()
        setCurrentCommand( previous )

    def __del__( self ):
        """Destructor: call DEFI_FICHIER to release the logical unit."""
        previous = getCurrentCommand()
        setCurrentCommand( None )
        syntax = CommandSyntax( "DEFI_FICHIER" )
        syntax.define( _F( ACTION="LIBERER",
                           UNITE=self.unit,
                           FICHIER=self.filename,
                         )
                     )
        cdef INTEGER numOp = 26
        libaster.opsexe_( &numOp )
        syntax.free()
        setCurrentCommand( previous )

        self._free_number.append(self.unit)

    @property
    def unit( self ):
        """Attributes that holds the logical unit associated to this file"""
        return self._logicalUnit

    @property
    def filename( self ):
        """Attributes that holds the file name"""
        return self._filename

    @classmethod
    def from_name(cls, filename):
        """Return the logical unit associated to a unit number."""
        def _predicate(item):
            return item[1] == filename

        try:
            unit = ifilter(_predicate, cls._used_unit.items())[0]
        except StopIteration:
            unit = -1
        return cls.from_number(unit)

    @classmethod
    def from_number(cls, unit):
        """Return the logical unit associated to a unit number."""
        return cls._used_unit.get(unit)

    @classmethod
    def _register(cls, logicalUnit):
        """Register a logical unit with its file name."""
        print "DEBUG: register unit", logicalUnit.unit
        cls._used_unit[logicalUnit.unit] = logicalUnit

    @classmethod
    def release_from_number(cls, unitToRelease):
        """Release a logical unit"""
        print "DEBUG: release unit", unitToRelease
        try:
            del cls._used_unit[unitToRelease]
        except KeyError:
            msg = "Unable to free the logical unit {}".format(unitToRelease)
            raise KeyError(msg)

    @classmethod
    def release_from_name(cls, filename):
        """Release a logical unit by file name"""
        unit = cls.from_name(filename)
        if not unit:
            msg = "file {!r} not asspociated".format(filename)
            raise KeyError(msg)
        cls.release_from_number(unit)

    @classmethod
    def _get_free_number(cls):
        """Return the next free unit."""
        if not cls._free_number:
            raise ValueError("No more free logical unit")
        return cls._free_number.pop()


cdef public void newLogicalUnitFile( const char* name, const int type, const int access ):
    LogicalUnitFile( name, type, access )

cdef public void deleteLogicalUnitFile( const char* name ):
    LogicalUnitFile.release_from_name(name)

cdef public int getFileLogicalUnit( const char* name ):
    global cppFileDict
    pyName = <bytes> name
    returnInt = cppFileDict[ pyName ].getLogicalUnit()
    return returnInt

cdef public string getTemporaryFileName( const char* dir ):
    dirPython = <bytes> dir
    cdef string tmpfile = tempfile.NamedTemporaryFile( dir = dirPython ).name
    return tmpfile
