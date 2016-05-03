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
from libcpp.vector cimport vector

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDoublePtr
from code_aster.Mesh.Mesh cimport MeshPtr
from code_aster.Function.Function cimport FunctionPtr
from code_aster.Modeling.CrackShape cimport CrackShapePtr

from code_aster.Modeling.CrackShape import NoShape, Ellipse

cdef extern from "Modeling/XfemCrack.h":

    ctypedef vector[ string ] VectorString
    ctypedef vector[ double ] VectorDouble

    cdef cppclass XfemCrackInstance:

        XfemCrackInstance(MeshPtr& currentMesh)

        bint build() except +

        MeshPtr getSupportMesh()

        void setSupportMesh( MeshPtr &supportMesh)

        MeshPtr getAuxiliaryGrid()

        void setAuxiliaryGrid( MeshPtr &auxiliaryGrid)

        XfemCrackPtr getExistingCrackWithGrid()

        void setExistingCrackWithGrid( XfemCrackPtr &existingCrackWithGrid)

        string getDiscontinuityType()

        void setDiscontinuityType( string &discontinuityType)

        VectorString getCrackLipsEntity()

        void setCrackLipsEntity( VectorString &crackLips)

        VectorString getCrackTipEntity()

        void setCrackTipEntity( VectorString &crackTip)

        VectorString getCohesiveCrackTipForPropagation()

        void setCohesiveCrackTipForPropagation( VectorString &crackTipEntity)

        FunctionPtr getNormalLevelSetFunction()

        void setNormalLevelSetFunction( FunctionPtr &normalLevelSetFunction)

        FunctionPtr getTangentialLevelSetFunction()

        void setTangentialLevelSetFunction( FunctionPtr &tangentialLevelSetFunction)

        CrackShapePtr getCrackShape()

        void setCrackShape( CrackShapePtr &crackShape)

        FieldOnNodesDoublePtr getNormalLevelSetField()

        void setNormalLevelSetField( FieldOnNodesDoublePtr &normalLevelSetField)

        FieldOnNodesDoublePtr getTangentialLevelSet()

        void setTangentialLevelSet( FieldOnNodesDoublePtr &tangentialLevelSet)

        VectorString getEnrichedElements()

        void setEnrichedElements( VectorString &enrichedElements)

        string getDiscontinuousField()

        void setDiscontinuousField(string &discontinuousField)

        string getEnrichmentType()

        string setEnrichmentType(string &enrichmentType)

        double getEnrichmentRadiusZone()

        void setEnrichmentRadiusZone(double enrichmentRadiusZone)

        long getEnrichedLayersNumber()

        void setEnrichedLayersNumber(long enrichedLayersNumber)

        vector[XfemCrackPtr] getJunctingCracks()

        void insertJunctingCracks( XfemCrackPtr &junctingCracks)

        void setPointForJunction(VectorDouble &point)

        string getJeveuxName()

        void debugPrint( int logicalUnit )


    cdef cppclass XfemCrackPtr:

        XfemCrackPtr( XfemCrackPtr& )
        XfemCrackPtr( XfemCrackInstance* )
        XfemCrackInstance* get()


cdef class XfemCrack:

    cdef XfemCrackPtr* _cptr

    cdef set( self, XfemCrackPtr other )
    cdef XfemCrackPtr* getPtr( self )
    cdef XfemCrackInstance* getInstance( self )
