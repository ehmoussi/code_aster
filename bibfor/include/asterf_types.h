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

#ifndef ASTERF_TYPES_H
#define ASTERF_TYPES_H
!
! Definition of types used by aster
!
#include "asterf.h"
!
#define aster_int_kind ASTER_INT_SIZE
#define aster_int integer(kind=aster_int_kind)
#define to_aster_int(a) int(a, ASTER_INT_SIZE)
!
#define aster_logical_kind ASTER_LOGICAL_SIZE
#define aster_logical logical(kind=aster_logical_kind)
#define to_aster_logical(a) logical(a, ASTER_LOGICAL_SIZE)
!
#define ASTER_TRUE to_aster_logical(.true.)
#define ASTER_FALSE to_aster_logical(.false.)
!
#ifdef _DISABLE_MED
#   define MED_INT_SIZE 4
#endif
#define med_int_kind MED_INT_SIZE
#define med_int integer(kind=med_int_kind)
#define to_med_int(a) int(a, MED_INT_SIZE)
!
#ifndef _USE_MPI
#   define MPI_INT_SIZE 4
#endif
#define mpi_int_kind MPI_INT_SIZE
#define mpi_int integer(kind=mpi_int_kind)
#define mpi_bool logical(kind=mpi_int_kind)
#define to_mpi_int(a) int(a, MPI_INT_SIZE)
!
#ifdef _DISABLE_MUMPS
#   define MUMPS_INT_SIZE 4
#endif
#define mumps_int_kind MUMPS_INT_SIZE
#define mumps_int integer(kind=mumps_int_kind)
#define to_mumps_int(a) int(a, MUMPS_INT_SIZE)
!
#define blas_int_kind BLAS_INT_SIZE
#define blas_int integer(kind=blas_int_kind)
#define to_blas_int(a) int(a, BLAS_INT_SIZE)
!
#define to_petsc_int(a) int(a, 4)
!
#endif
