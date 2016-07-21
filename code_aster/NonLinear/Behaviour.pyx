# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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


cdef class Behaviour( DataStructure ):
    """Python wrapper on the C++ Behaviour Object"""

    def __cinit__( self, ConstitutiveLawEnum curLaw , StrainEnum curStrain ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new BehaviourPtr( new BehaviourInstance( curLaw, curStrain ) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, BehaviourPtr other ):
        """Point to an existing object"""
        self._cptr = new BehaviourPtr( other )

    cdef BehaviourPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef BehaviourInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()
    
    def setTangentMatrix( self, TangentMatrixEnum curMat) :
        """ Set the type of tangent matrix """
        self.getInstance().setTangentMatrix( curMat )

    def setAlpha( self, double alpha ):
        """ Set alpha parameter """
        self.getInstance().setAlpha( alpha )

    def setTheta( self, double theta ): 
        """ Set theta parameter """
        self.getInstance().setTheta( theta )

    def setRadialRelativeResidual ( self, double radialRelativeResidual ):
        """ Set the Radial Relative Residual """
        self.getInstance().setRadialRelativeResidual ( radialRelativeResidual )
    
    def setPlasticityCreepConstitutiveLaw( self,ConstitutiveLawEnum law1, ConstitutiveLawEnum law2 ):
        """ Set Laws for plasticity ad creep """ 
        self.getInstance().setPlasticityCreepConstitutiveLaw( law1, law2 ) 

    def setPlaneStressMaximumResidual( self,double planeStressMaximumResidual ):
        """ Set the Plane Stress Maximum Residual """ 
        self.getInstance().setPlaneStressMaximumResidual( planeStressMaximumResidual )

    def setPlaneStressRelativeResidual( self, double planeStressRelativeResidual ):
        """ Set the Plane Stress Relative Residual """
        self.getInstance().setPlaneStressRelativeResidual( planeStressRelativeResidual )

    def setPlaneStressMaximumIteration( self, int maxIter ):
        """ Set the maximum number of iterations for the integration of the constitutive law """
        self.getInstance().setPlaneStressMaximumIteration( maxIter )
