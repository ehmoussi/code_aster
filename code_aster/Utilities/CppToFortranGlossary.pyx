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

from cython.operator cimport dereference as deref

cdef class FortranGlossary:
    def __cinit__( self ):
        self._cptr = getGlossary()

    def getComponent( self, searchComp ):
        return deref( self._cptr ).getComponent( searchComp )

    def getModeling( self, searchMod ):
        return deref( self._cptr ).getModeling( searchMod )

    def getPhysics( self, searchPhysics ):
        return deref( self._cptr ).getPhysics( searchPhysics )

    def getRenumbering( self, searchRenum ):
        return deref( self._cptr ).getRenumbering( searchRenum )

    def getSolver( self, searchSol ):
        return deref( self._cptr ).getSolver( searchSol )
