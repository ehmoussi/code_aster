! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! --------------------------------------------------------------------------------------------------
!
! The field <COMPOR>
!   List of strings (K16) for each cell
!   Definition of behaviour (relation, strain model, number of internal state vari, etc.)
!
! --------------------------------------------------------------------------------------------------
!
! Size
!
#define COMPOR_SIZE 21
!
! Slots: general
!
#define RELA_NAME    1
#define NVAR         2
#define DEFO         3
#define INCRELAS     4
#define PLANESTRESS  5
#define NUME         6
#define MULTCOMP     7
#define POSTITER     8
#define DEFO_LDC     21
!
! Slots: for KIT
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
! Slots: for KIT_THM
!
#define THMC_NAME    9
#define THER_NAME    10
#define HYDR_NAME    11
#define MECA_NAME    12
#define THMC_NUME    13
#define THER_NUME    14
#define HYDR_NUME    15
#define MECA_NUME    16
#define THMC_NVAR    17
#define THER_NVAR    18
#define HYDR_NVAR    19
#define MECA_NVAR    20
!
! Slots: for KIT_DDI
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
! Slots: for KIT_META
!
#define META_NAME    9
!
! Slots: for KIT_CG
!
#define CABLE_NAME   9
#define SHEATH_NAME  10

! --------------------------------------------------------------------------------------------------
!
! The field <CARCRI>
!   List of real for each cell
!   Parameters to solve behaviour equations
!
! --------------------------------------------------------------------------------------------------
!
! Size
!
#define CARCRI_SIZE    26
!
! Slots: for external state variables
!
#define IVARIEXT1      11
#define IVARIEXT2      23
!
! Slots: for HHO parameters
!
#define HHO_COEF       24
#define HHO_STAB       25
#define HHO_CALC       26
!
! type for HHO parameters
!
#define HHO_STAB_AUTO 1
#define HHO_STAB_MANU 2
#define HHO_CALC_YES  1
#define HHO_CALC_NO   2
!
!        type of external state variables
!
#define ELTSIZE1  1
#define ELTSIZE2  2
#define XXXXXXXX  3
#define GRADVELO  4
#define HYGR      5
#define NEUT1     6
#define NEUT2     7
#define TEMP      8
#define DTX       9
#define DTY       10
#define DTZ       11
#define X         12
#define Y         13
#define Z         14
#define SECH      15
#define HYDR      16
#define CORR      17
#define IRRA      18
#define EPSAXX    19
#define EPSAYY    20
#define EPSAZZ    21
#define EPSAXY    22
#define EPSAXZ    23
#define EPSAYZ    24
#define ZFERRITE  25
#define ZPERLITE  26
#define ZBAINITE  27
#define ZMARTENS  28
#define ZALPHPUR  29
#define ZALPHBET  30
#define TIME      31
!
! Slots: for THM parameters
!
#define PARM_ALPHA_THM 18
#define PARM_THETA_THM 12
!
! Slots: strain model for MFRONT
!
#define ISTRAINEXTE    22
!
!        type of strain model for MFRONT
!
#define MFRONT_STRAIN_SMALL          0
#define MFRONT_STRAIN_SIMOMIEHE      1
#define MFRONT_STRAIN_GROTGDEP       2
#define MFRONT_STRAIN_UNDETERMINATED 3
#define MFRONT_STRAIN_GROTGDEP_S     4
#define MFRONT_STRAIN_GROTGDEP_L     5

! Set to 1 to activate DEBUG (careful, very verbose, at each Gauss point !)
#define LDC_PREP_DEBUG               0
