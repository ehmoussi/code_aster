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

module parameters_module
    implicit none
!
! person_in_charge: mathieu.courtois@edf.fr
! aslint: disable=W1403

! ------------------------------------------------------------------------------
!   Define some constant values shared by several subroutines
!
!   Constant values to check status in parallel
!
!   ST_OK and ST_ER can be used for all boolean tests.
!
!   ST_OK and others ST_xxx values allow binary operations to be more
!   precise.
!
!   ST_ER and ST_xxx constants must not be used together.
!
!   ST_ER_PR0 : error on processor #0
!   ST_ER_OTH : error on another processor
!   ST_UN_OTH : undefined status for another processor
!   ST_EXCEPT : not a fatal error, an exception
!
!   ST_TAG_CHK : mpi communication tag for the check step of the status
!   ST_TAG_CNT : mpi communication tag for the continue or stop
!   ST_TAG_ALR : mpi communication tag for the alarm check
!
#include "asterf_types.h"
!
    integer, parameter :: ST_ER     =  1
    integer, parameter :: ST_OK     =  0
    integer, parameter :: ST_ER_PR0 =  4
    integer, parameter :: ST_ER_OTH =  8
    integer, parameter :: ST_UN_OTH = 16
    integer, parameter :: ST_EXCEPT = 32
!
    mpi_int, parameter :: ST_TAG_CHK = to_mpi_int(123111)
    mpi_int, parameter :: ST_TAG_CNT = to_mpi_int(123222)
    mpi_int, parameter :: ST_TAG_ALR = to_mpi_int(123333)
!
end module
