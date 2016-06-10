# coding: utf-8

# Copyright (C) 1991 - 2015  EDF RD                www.code-aster.org
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
from cython.operator cimport preincrement as inc, dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Mesh.Mesh cimport Mesh
from code_aster.Function.Function cimport Function
from code_aster.Modeling.CrackShape cimport CrackShape
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble


cdef class XfemCrack( DataStructure ):
    """Python wrapper on the C++ XfemCrack object"""

    def __cinit__( self, Mesh supportMesh, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new XfemCrackPtr( new XfemCrackInstance( deref(supportMesh.getPtr()) ) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, XfemCrackPtr other ):
        """Point to an existing object"""
        self._cptr = new XfemCrackPtr( other )

    cdef XfemCrackPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef XfemCrackInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def getType(self):
        """Return the type of DataStructure"""
        return self.getInstance().getType()

    def build( self ):
        """Build the XfemCrack"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def getSupportMesh(self):
        mesh = Mesh()
        mesh.set(self.getInstance().getSupportMesh())
        return mesh

    def setSupportMesh(self, Mesh supportMesh):
        self.getInstance().setSupportMesh(deref (supportMesh.getPtr()))

    def getAuxiliaryGrid(self):
        mesh = Mesh()
        mesh.set(self.getInstance().getAuxiliaryGrid())
        return mesh

    def setAuxiliaryGrid(self, Mesh auxiliaryGrid):
        self.getInstance().setAuxiliaryGrid(deref (auxiliaryGrid.getPtr()) )

    def getExistingCrackWithGrid(self):
        crack = XfemCrack()
        crack.set(self.getInstance().getExistingCrackWithGrid())
        return crack

    def setExistingCrackWithGrid(self, XfemCrack existingCrackWithGrid):
        self.getInstance().setExistingCrackWithGrid(deref (existingCrackWithGrid.getPtr()))

    def getDiscontinuityType(self):
        return self.getInstance().getDiscontinuityType()

    def setDiscontinuityType(self, string discontinuityType):
        self.getInstance().setDiscontinuityType(discontinuityType)

    def getCrackLipsEntity(self):
        return self.getInstance().getCrackLipsEntity()

    def setCrackLipsEntity(self,  crackLips):
        self.getInstance().setCrackLipsEntity(crackLips)

    def getCrackTipEntity(self):
        return self.getInstance().getCrackTipEntity()

    def setCrackTipEntity(self,  crackTip):
        self.getInstance().setCrackTipEntity(crackTip)

    def getCohesiveCrackTipForPropagation(self):
        return self.getInstance().getCohesiveCrackTipForPropagation()

    def setCohesiveCrackTipForPropagation(self,  crackTipEntity):
        self.getInstance().setCohesiveCrackTipForPropagation(crackTipEntity)

    def getNormalLevelSetFunction(self):
        func = Function()
        func.set(self.getInstance().getNormalLevelSetFunction())
        return func

    def setNormalLevelSetFunction(self, Function normalLevelSetFunction):
        self.getInstance().setNormalLevelSetFunction(deref (normalLevelSetFunction.getPtr()))

    def getTangentialLevelSetFunction(self):
        func = Function()
        func.set(self.getInstance().getTangentialLevelSetFunction())
        return func

    def setTangentialLevelSetFunction(self, Function tangentialLevelSetFunction):
        self.getInstance().setTangentialLevelSetFunction(deref (tangentialLevelSetFunction.getPtr()))

    def getCrackShape(self):
        shape = CrackShape()
        shape.set(self.getInstance().getCrackShape())
        return shape

    def setCrackShape(self, CrackShape crackShape):
        self.getInstance().setCrackShape(deref (crackShape.getPtr()))

    def getNormalLevelSetField(self):
        field = FieldOnNodesDouble()
        field.set( self.getInstance().getNormalLevelSetField() )
        return field

    def setNormalLevelSetField(self, FieldOnNodesDouble normalLevelSetField):
        self.getInstance().setNormalLevelSetField(deref (normalLevelSetField.getPtr()))

    def getTangentialLevelSetField(self):
        field = FieldOnNodesDouble()
        field.set( self.getInstance().getTangentialLevelSetField() )
        return field

    def setTangentialLevelSetField(self, FieldOnNodesDouble tangentialLevelSet):
        self.getInstance().setTangentialLevelSetField(deref (tangentialLevelSet.getPtr()))

    def getEnrichedElements(self):
        return self.getInstance().getEnrichedElements()

    def setEnrichedElements(self,  enrichedElements):
        self.getInstance().setEnrichedElements(enrichedElements)

    def getDiscontinuousField(self):
        return self.getInstance().getDiscontinuousField()

    def setDiscontinuousField(self, string discontinuousField):
        self.getInstance().setDiscontinuousField( discontinuousField )

    def getEnrichmentType(self):
        return self.getInstance().getEnrichmentType()

    def setEnrichmentType(self, string enrichmentType):
        self.getInstance().setEnrichmentType(enrichmentType)

    def getEnrichmentRadiusZone(self):
        return self.getInstance().getEnrichmentRadiusZone()

    def setEnrichmentRadiusZone(self, double enrichmentRadiusZone):
        self.getInstance().setEnrichmentRadiusZone(enrichmentRadiusZone)

    def getEnrichedLayersNumber(self):
        return self.getInstance().getEnrichedLayersNumber()

    def setEnrichedLayersNumber(self, long enrichedLayersNumber):
        self.getInstance().setEnrichedLayersNumber(enrichedLayersNumber)

    def getJunctingCracks(self):
        l_crack=[]
        cdef XfemCrackPtr *cpp_crack
        cdef vector[XfemCrackPtr].iterator iter = self.getInstance().getJunctingCracks().begin()
        cdef vector[XfemCrackPtr].iterator end = self.getInstance().getJunctingCracks().end()
        while iter < end:
            cpp_crack = &deref(iter)
            inc(iter)
            crack = XfemCrack()
            crack.set(deref (cpp_crack))
            l_crack.append(crack)
        return l_crack

    def insertJunctingCracks(self, XfemCrack junctingCracks):
        self.getInstance().insertJunctingCracks(deref (junctingCracks.getPtr()))

    def setPointForJunction(self, VectorDouble point):
        self.getInstance().setPointForJunction(point)

    def getJeveuxName(self):
        return self.getInstance().getJeveuxName()

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
