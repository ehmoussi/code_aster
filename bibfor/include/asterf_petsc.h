! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

#ifndef ASTERF_PETSC_H
#define ASTERF_PETSC_H

#include "asterf_types.h"

#ifdef _HAVE_PETSC
!
!    include necessaire a la gestion des instances PETSC
!----------------------------------------------------------------
!
#include <petscversion.h>

! Inclusion des interfaces Fortran de PETSc définies
! dans la librairie
#if PETSC_VERSION_LT(3,6,0)
#include <finclude/petscsys.h>
#include <finclude/petscvec.h>
#include <finclude/petscvec.h90>
#include <finclude/petscmat.h>
#include <finclude/petscmat.h90>
#include <finclude/petscpc.h>
#include <finclude/petscpc.h90>
#include <finclude/petscksp.h>
#include <finclude/petscksp.h90>
#include <finclude/petscviewer.h>
#include <finclude/petscviewer.h90>

#else
#ifndef PETSC_USE_FORTRAN_MODULES
#define PETSC_USE_FORTRAN_MODULES
#endif
#include <petsc/finclude/petscsysdef.h>
#include <petsc/finclude/petscvecdef.h>
#include <petsc/finclude/petscmatdef.h>
#include <petsc/finclude/petscpcdef.h>
#include <petsc/finclude/petsckspdef.h>
#include <petsc/finclude/petscviewerdef.h>
use petscsys
use petscvec
use petscmat
use petscpc
use petscksp
!
#endif
!
#endif
#endif
