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
!
! Behaviour data structure : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!
!
! - Access in <COMPOR> - Behaviour field - General
!
#define NB_COMP_MAXI 20
#define NAME         1
#define NVAR         2
#define DEFO         3
#define INCRELAS     4
#define PLANESTRESS  5
#define NUME         6
#define MULTCOMP     7
#define POSTITER     8
!
! - Access in <COMPOR> - Behaviour field - KITs
!
#define KIT1_NAME    9
#define KIT2_NAME    10
#define KIT3_NAME    11
#define KIT4_NAME    12
#define KIT1_NUME    13
#define KIT2_NUME    14
#define KIT1_NVAR    15
#define KIT2_NVAR    16
#define KIT3_NVAR    17
#define KIT4_NVAR    18
!
! - Access in <COMPOR> - Behaviour field - KIT_THM
!
#define THMC_NAME    9
#define THER_NAME    10
#define HYDR_NAME    11
#define MECA_NAME    12
#define MECA_NUME    13
#define THMC_NVAR    15
#define THER_NVAR    16
#define HYDR_NVAR    17
#define MECA_NVAR    18
!
! - Access in <COMPOR> - Behaviour field - KIT_DDI
!
#define CREEP_NAME   9
#define PLAS_NAME    10
#define COUPL_NAME   11
#define CPLA_NAME    12
#define CREEP_NUME   16
#define PLAS_NUME    15
#define CREEP_NVAR   17
#define PLAS_NVAR    18
!
! - Access in <COMPOR> - Behaviour field - KIT_META
!
#define META_NAME    9
!
! - Access in <COMPOR> - Behaviour field - KIT_CG
!
#define CABLE_NAME   9
#define SHEATH_NAME  10
