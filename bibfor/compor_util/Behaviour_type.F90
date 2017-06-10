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

module Behaviour_type
!
implicit none
!
#include "asterf_types.h"
!
! person_in_charge: mickael.abbas at edf.fr
!

!
! --------------------------------------------------------------------------------------------------
!
! Behaviour - Define types 
!
! --------------------------------------------------------------------------------------------------
!
! - Access in <COMPOR> - Behaviour field - General
!
    integer, parameter :: NB_COMP_MAXI = 20
    integer, parameter :: NAME         = 1
    integer, parameter :: NVAR         = 2
    integer, parameter :: DEFO         = 3
    integer, parameter :: INCRELAS     = 4
    integer, parameter :: PLANESTRESS  = 5
    integer, parameter :: NUME         = 6
    integer, parameter :: MULTCOMP     = 7
    integer, parameter :: TYPEMATG     = 13
    integer, parameter :: POSTITER     = 14
!
! - Access in <COMPOR> - Behaviour field - KITs
!
    integer, parameter :: KIT1_NAME    = 8
    integer, parameter :: KIT2_NAME    = 9
    integer, parameter :: KIT3_NAME    = 10
    integer, parameter :: KIT4_NAME    = 11
    integer, parameter :: KIT1_NUME    = 15
    integer, parameter :: KIT2_NUME    = 16
    integer, parameter :: KIT1_NVAR    = 17
    integer, parameter :: KIT2_NVAR    = 18
    integer, parameter :: KIT3_NVAR    = 19
    integer, parameter :: KIT4_NVAR    = 20
!
! - Access in <COMPOR> - Behaviour field - KIT_THM
!
    integer, parameter :: THMC_NAME    = 8
    integer, parameter :: THER_NAME    = 9
    integer, parameter :: HYDR_NAME    = 10
    integer, parameter :: MECA_NAME    = 11
    integer, parameter :: MECA_NUME    = 15
    integer, parameter :: THMC_NVAR    = 17
    integer, parameter :: THER_NVAR    = 18
    integer, parameter :: HYDR_NVAR    = 19
    integer, parameter :: MECA_NVAR    = 20
!
! - Access in <COMPOR> - Behaviour field - KIT_DDI
!
    integer, parameter :: CREEP_NAME   = 8
    integer, parameter :: PLAS_NAME    = 9
    integer, parameter :: COUPL_NAME   = 10
    integer, parameter :: CPLA_NAME    = 11
    integer, parameter :: CREEP_NUME   = 16
    integer, parameter :: PLAS_NUME    = 15
    integer, parameter :: CREEP_NVAR   = 17
    integer, parameter :: PLAS_NVAR    = 18
!
! - Access in <COMPOR> - Behaviour field - KIT_META
!
    integer, parameter :: META_NAME    = 8
!
! - Access in <COMPOR> - Behaviour field - KIT_CG
!
    integer, parameter :: CABLE_NAME   = 8
    integer, parameter :: SHEATH_NAME  = 9
!
end module
