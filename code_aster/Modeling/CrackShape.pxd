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
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

from libcpp.string cimport string
from libcpp.vector cimport vector

from code_aster.Mesh.Mesh cimport MeshPtr


cdef extern from "Modeling/CrackShape.h":

    cdef enum Shape :
        cNoShape 	"NoShape"
        cEllipse 	"Ellipse"
        cSquare 	"Square"
        cCylinder 	"Cylinder"
        cNotch 		"Notch"
        cHalfPlane 	"HalfPlane"
        cSegment 	"Segment"
        cHalfLine 	"HalfLine"
        cLine 		"Line"


    ctypedef vector[ double ] VectorDouble

    cdef cppclass CrackShapeInstance:

        CrackShapeInstance()

        void setEllipseCrackShape(double semiMajorAxis, double semiMinorAxis, VectorDouble center, VectorDouble vectX, VectorDouble vectY, string crackSide)

        void setSquareCrackShape(double semiMajorAxis, double semiMinorAxis, double filletRadius, VectorDouble center, VectorDouble vectX, VectorDouble vectY, string crackSide)

        void setCylinderCrackShape(double semiMajorAxis, double semiMinorAxis, VectorDouble center, VectorDouble vectX, VectorDouble vectY)

        void setNotchCrackShape(double halfLength, double filletRadius, VectorDouble center, VectorDouble vectX, VectorDouble vectY)

        void setHalfPlaneCrackShape(VectorDouble endPoint, VectorDouble normal, VectorDouble tangent)

        void setSegmentCrackShape(VectorDouble startingPoint, VectorDouble endPoint)

        void setHalfLineCrackShape(VectorDouble startingPoint, VectorDouble tangent)

        void setLineCrackShape(VectorDouble startingPoint, VectorDouble tangent)

        Shape getShape() const

        string getShapeName() const

        double getSemiMajorAxis() const

        double getSemiMinorAxis() const

        const VectorDouble getCenter() const

        const VectorDouble getVectX() const

        const VectorDouble getVectY() const

        string getCrackSide() const

        double getFilletRadius() const

        double getHalfLength() const

        const VectorDouble getEndPoint() const

        const VectorDouble getNormal() const

        const VectorDouble getTangent() const

        const VectorDouble getStartingPoint() const


    cdef cppclass CrackShapePtr:

        CrackShapePtr( CrackShapePtr& )
        CrackShapePtr( CrackShapeInstance* )
        CrackShapeInstance* get()


cdef class CrackShape:

    cdef CrackShapePtr* _cptr

    cdef set( self, CrackShapePtr other )
    cdef CrackShapePtr* getPtr( self )
    cdef CrackShapeInstance* getInstance( self )
