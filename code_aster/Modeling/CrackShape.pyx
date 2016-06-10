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
from cython.operator cimport dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure

NoShape, Ellipse, Square, Cylinder, Notch, HalfPlane, Segment, HalfLine, Line = cNoShape,  cEllipse, cSquare, cCylinder, cNotch, cHalfPlane, cSegment, cHalfLine, cLine


cdef class CrackShape( DataStructure ):
    """Python wrapper on the C++ CrackShape object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new CrackShapePtr( new CrackShapeInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, CrackShapePtr other ):
        """Point to an existing object"""
        self._cptr = new CrackShapePtr( other )

    cdef CrackShapePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef CrackShapeInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setEllipseCrackShape(self, double semiMajorAxis, double semiMinorAxis, VectorDouble center, VectorDouble vectX, VectorDouble vectY, string crackSide="IN"):
        self.getInstance().setEllipseCrackShape(semiMajorAxis, semiMinorAxis, center, vectX, vectY, crackSide)

    def setSquareCrackShape(self, double semiMajorAxis, double semiMinorAxis, double filletRadius, VectorDouble center, VectorDouble vectX, VectorDouble vectY, string crackSide="IN"):
        self.getInstance().setSquareCrackShape(semiMajorAxis, semiMinorAxis, filletRadius, center, vectX, vectY, crackSide)

    def setCylinderCrackShape(self, double semiMajorAxis, double semiMinorAxis, VectorDouble center, VectorDouble vectX, VectorDouble vectY):
        self.getInstance().setCylinderCrackShape(semiMajorAxis, semiMinorAxis, center, vectX, vectY )

    def setNotchCrackShape(self, double halfLength, double filletRadius, VectorDouble center, VectorDouble vectX, VectorDouble vectY):
        self.getInstance().setNotchCrackShape(halfLength, filletRadius, center, vectX, vectY )

    def setHalfPlaneCrackShape(self, VectorDouble endPoint, VectorDouble normal, VectorDouble tangent):
        self.getInstance().setHalfPlaneCrackShape(endPoint, normal, tangent )

    def setSegmentCrackShape(self, VectorDouble startingPoint, VectorDouble endPoint):
        self.getInstance().setSegmentCrackShape(startingPoint, endPoint )

    def setHalfLineCrackShape(self, VectorDouble startingPoint, VectorDouble tangent):
        self.getInstance().setHalfLineCrackShape(startingPoint, tangent )

    def setLineCrackShape(self, VectorDouble startingPoint, VectorDouble tangent):
        self.getInstance().setLineCrackShape(startingPoint, tangent )

    def getShape(self):
        return self.getInstance().getShape()

    def getShapeName(self):
        return self.getInstance().getShapeName()

    def getSemiMajorAxis(self):
        return self.getInstance().getSemiMajorAxis()

    def getSemiMinorAxis(self):
        return self.getInstance().getSemiMinorAxis()

    def getCenter(self):
        return self.getInstance().getCenter()

    def getVectX(self):
        return self.getInstance().getVectX()

    def getVectY(self):
        return self.getInstance().getVectY()

    def getCrackSide(self):
        return self.getInstance().getCrackSide()

    def getFilletRadius(self):
        return self.getInstance().getFilletRadius()

    def getHalfLength(self):
        return self.getInstance().getHalfLength()

    def getEndPoint(self):
        return self.getInstance().getEndPoint()

    def getNormal(self):
        return self.getInstance().getNormal()

    def getTangent(self):
        return self.getInstance().getTangent()

    def getStartingPoint(self):
        return self.getInstance().getStartingPoint()
