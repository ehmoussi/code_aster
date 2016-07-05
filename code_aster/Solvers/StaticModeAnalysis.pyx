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

import cython
from libcpp.string cimport string
from cython.operator cimport dereference as deref
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDouble
from code_aster.LinearAlgebra.LinearSolver cimport LinearSolver
from code_aster.Results.ResultsContainer cimport ResultsContainer

# numpy implementation in cython currently generates a warning at compilation
import numpy as np
cimport numpy as np
np.import_array()


cdef class StaticModeDepl:
    """Python wrapper on the C++ StaticModeDepl object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new StaticModeDeplPtr( new StaticModeDeplInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StaticModeDeplPtr other ):
        """Point to an existing object"""
        self._cptr = new StaticModeDeplPtr( other )

    cdef StaticModeDeplPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StaticModeDeplInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setMassMatrix( self , AssemblyMatrixDouble Matrix ):
        """Define Mass matrix """
        self.getInstance().setMassMatrix( deref (Matrix.getPtr()))
        
    def setStiffMatrix( self, AssemblyMatrixDouble Matrix ):
        """Define Stiffness matrix """
        self.getInstance().setStiffMatrix(deref (Matrix.getPtr()))
    
    def setLinearSolver( self,LinearSolver Solver ):
        """Define linear solver """
        self.getInstance().setLinearSolver(deref(Solver.getPtr()))
        
    def setAllLoc(self):
        """Set all nodes wanted """
        self.getInstance().setAllLoc()
        
    def setAllCmp(self):
        """Set all component wanted """
        self.getInstance().setAllCmp()
    
    def Wantedgrno(self , listloc):
        """Set group of nodes of interest """
        self.getInstance().WantedGrno(listloc)
    
    def Unwantedcmp(self , listcmp):
        """Set unwanted components"""
        self.getInstance().Unwantedcmp(listcmp)

    def Wantedcmp(self , listcmp):
        """Set Wanted components"""
        self.getInstance().Wantedcmp(listcmp)    
    
    def execute(self):
        """Execution of fortran operator 93""" 
        results = ResultsContainer()
        results.set( self.getInstance().execute() )
        return results
        
####      
cdef class StaticModeForc:
    """Python wrapper on the C++ StaticModeDepl object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new StaticModeForcPtr( new StaticModeForcInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StaticModeForcPtr other ):
        """Point to an existing object"""
        self._cptr = new StaticModeForcPtr( other )

    cdef StaticModeForcPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StaticModeForcInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()


    def setMassMatrix( self , AssemblyMatrixDouble Matrix ):
        """Define Mass matrix """
        self.getInstance().setMassMatrix( deref (Matrix.getPtr()))
        
    def setStiffMatrix( self, AssemblyMatrixDouble Matrix ):
        """Define Stiffness matrix """
        self.getInstance().setStiffMatrix(deref (Matrix.getPtr()))
    
    def setLinearSolver( self,LinearSolver Solver ):
        """Define linear solver """
        self.getInstance().setLinearSolver(deref(Solver.getPtr()))
        
    def setAllLoc(self):
        """Set all nodes wanted """
        self.getInstance().setAllLoc()
        
    def setAllCmp(self):
        """Set all component wanted """
        self.getInstance().setAllCmp()
    
    def Wantedgrno(self , listloc):
        """Set group of nodes of interest """
        self.getInstance().WantedGrno(listloc)
    
    def Unwantedcmp(self , listcmp):
        """Set unwanted components"""
        self.getInstance().Unwantedcmp(listcmp)

    def Wantedcmp(self , listcmp):
        """Set Wanted components"""
        self.getInstance().Wantedcmp(listcmp)    
    
    def execute(self):
        """Execution of fortran operator 93""" 
        results = ResultsContainer()
        results.set( self.getInstance().execute() )
        return results
####
cdef class StaticModePseudo:
    """Python wrapper on the C++ StaticModeDepl object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new StaticModePseudoPtr( new StaticModePseudoInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StaticModePseudoPtr other ):
        """Point to an existing object"""
        self._cptr = new StaticModePseudoPtr( other )

    cdef StaticModePseudoPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StaticModePseudoInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setMassMatrix( self , AssemblyMatrixDouble Matrix ):
        """Define Mass matrix """
        self.getInstance().setMassMatrix( deref (Matrix.getPtr()))
        
    def setStiffMatrix( self, AssemblyMatrixDouble Matrix ):
        """Define Stiffness matrix """
        self.getInstance().setStiffMatrix(deref (Matrix.getPtr()))
    
    def setLinearSolver( self,LinearSolver Solver ):
        """Define linear solver """
        self.getInstance().setLinearSolver(deref(Solver.getPtr()))
        
    def setAllLoc(self):
        """Set all nodes wanted """
        self.getInstance().setAllLoc()
        
    def setAllCmp(self):
        """Set all component wanted """
        self.getInstance().setAllCmp()
    
    def WantedGrno(self , listloc):
        """Set group of nodes of interest """
        self.getInstance().WantedGrno(listloc)
        
    def WantedDir(self , wdir):
        """Set group of nodes of interest """
        self.getInstance().WantedDir(wdir)
    
    def setDirname(self, dirname):
        self.getInstance().setDirname(dirname)
        
    def WantedAxe(self , listaxe):
        """Set group of nodes of interest """
        self.getInstance().WantedAxe(listaxe)
    
    def Unwantedcmp(self , listcmp):
        """Set unwanted components"""
        self.getInstance().Unwantedcmp(listcmp)

    def Wantedcmp(self , listcmp):
        """Set Wanted components"""
        self.getInstance().Wantedcmp(listcmp)    
    
    def execute(self):
        """Execution of fortran operator 93""" 
        results = ResultsContainer()
        results.set( self.getInstance().execute() )
        return results
####
cdef class StaticModeInterf:
    """Python wrapper on the C++ StaticModeDepl object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new StaticModeInterfPtr( new StaticModeInterfInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StaticModeInterfPtr other ):
        """Point to an existing object"""
        self._cptr = new StaticModeInterfPtr( other )

    cdef StaticModeInterfPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StaticModeInterfInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setMassMatrix( self , AssemblyMatrixDouble Matrix ):
        """Define Mass matrix """
        self.getInstance().setMassMatrix( deref (Matrix.getPtr()))
        
    def setStiffMatrix( self, AssemblyMatrixDouble Matrix ):
        """Define Stiffness matrix """
        self.getInstance().setStiffMatrix(deref (Matrix.getPtr()))
    
    def setLinearSolver( self,LinearSolver Solver ):
        """Define linear solver """
        self.getInstance().setLinearSolver(deref(Solver.getPtr()))
        
    def setAllLoc(self):
        """Set all nodes wanted """
        self.getInstance().setAllLoc()
        
    def setAllCmp(self):
        """Set all component wanted """
        self.getInstance().setAllCmp()
    
    def WantedGrno(self , listloc):
        """Set group of nodes of interest """
        self.getInstance().WantedGrno(listloc)
    
    def Unwantedcmp(self , listcmp):
        """Set unwanted components"""
        self.getInstance().Unwantedcmp(listcmp)

    def Wantedcmp(self , listcmp):
        """Set Wanted components"""
        self.getInstance().Wantedcmp(listcmp)
        
    def setNbmod(self , nb):
        """Set Wanted components"""
        self.getInstance().setNbmod(nb)
    
    def setShift(self , shift):
        """Set Wanted components"""
        self.getInstance().setShift(shift)        
    
    def execute(self):
        """Execution of fortran operator 93""" 
        results = ResultsContainer()
        results.set( self.getInstance().execute() )
        return results
