# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
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

include "astercython_config.pxi"

IF _HAVE_PETSC4PY == 1:
    from petsc4py cimport PETSc
    from petsc4py.PETSc cimport Mat
    from petsc4py.PETSc cimport PetscMat


def AssemblyMatrixToPetsc4Py(assemblyMatrix):
    IF _HAVE_PETSC4PY == 1:
        name = assemblyMatrix.getName().encode()
        cdef char* charName = name
        cdef PetscMat retour
        cdef PetscErrorCode ier
        CALL_MATASS2PETSC(charName, &retour, &ier)
        myMat = Mat()
        myMat.mat=retour
        return myMat
    ELSE:
        print("You must install Petsc4py to call this method")
