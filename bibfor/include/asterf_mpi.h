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

#ifndef ASTERF_MPI_H
#define ASTERF_MPI_H
!
! Define to use MPI integer variables that may have a different integer size at compilation
!
#ifdef _USE_MPI
!
#include "asterf_types.h"
!
#define MPI_MAX4                to_mpi_int(MPI_MAX)
#define MPI_MIN4                to_mpi_int(MPI_MIN)
#define MPI_SUM4                to_mpi_int(MPI_SUM)
!
#endif
!
#endif
