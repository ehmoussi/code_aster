# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
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

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster cimport libaster
from code_aster.libaster cimport INTEGER
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming
from code_aster.Supervis.libFile cimport LogicalUnitFile

from code_aster.Supervis.libCommandSyntax import _F
from code_aster.Supervis.libFile import FileType, FileAccess

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.DataFields.SimpleFieldOnElements cimport SimpleFieldOnElementsDouble


cdef class FieldOnElementsDouble(DataStructure):
    """Python wrapper on the C++ FieldOnElements object"""

    def __cinit__(self, string name=""):
        """Initialization: stores the pointer to the C++ object"""
        if len(name) > 0:
            self._cptr = new FieldOnElementsDoublePtr(new FieldOnElementsDoubleInstance(name))

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, FieldOnElementsDoublePtr other):
        """Point to an existing object"""
        self._cptr = new FieldOnElementsDoublePtr(other)

    cdef FieldOnElementsDoublePtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef FieldOnElementsDoubleInstance* getInstance(self):
        """Return the pointer on the c++ instance objet"""
        return self._cptr.get()

    #def exportToSimpleFieldOnElements(self):
        #"""Export the field to a SimpleFieldOnElementsDouble"""
        #returnField = SimpleFieldOnElementsDouble()
        #returnField.set( self.getInstance().exportToSimpleFieldOnElements() )
        #return returnField

    def debugPrint(self, logicalUnit = 6):
        """Print debug information of the content"""
        self.getInstance().debugPrint(logicalUnit)
