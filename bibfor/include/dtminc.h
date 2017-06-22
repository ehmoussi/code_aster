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

! Parameters definitions
! -------------------------------------------------------------------------
!
    integer :: parind(_DTM_NBPAR)
    character(len=3)  :: partyp(_DTM_NBPAR)
    character(len=8)  :: params(_DTM_NBPAR)

    data params /'ACC_WORK', 'ADAPT   ', 'ADRES_VC', 'AMOR_DIA', 'AMOR_FUL', &
                 'AMOR_MAT', 'APPND_SD', 'ARCH_NB ', 'ARCH_PER', 'ARCH_STO', &
                 'AR_LINST', 'A_ROT_F ', 'BASE_MOD', 'BASE_VEC', 'CALC_SD ', &
                 'COEF_MLT', 'DESC_FRC', 'DT      ', 'DT_MAX  ', 'DT_MIN  ', &
                 'FSI_ABSC', 'FSI_BASE', 'FSI_BASF', 'FSI_CASE', 'FSI_CODM', &
                 'FSI_CPLD', 'FSI_IRES', 'FSI_ITYP', 'FSI_PHIE', 'FSI_POID', &
                 'FSI_PRVI', 'FSI_RHOE', 'FSI_TYPF', 'FSI_VGAP', 'FSI_ZET0', &
                 'FUNC_NAM', 'F_NL_ADD', 'GYRO_FUL', 'IARCH_SD', 'IMP_ACCE', &
                 'IMP_DEPL', 'IMP_FEXT', 'IMP_VITE', 'IND_ALOC', 'INST_FIN', &
                 'INST_INI', 'MASS_DIA', 'MASS_FAC', 'MASS_FUL', 'MASS_MAT', &
                 'MAT_DESC', 'MULTI_AP', 'NB_EXC_T', 'NB_MODES', 'NB_NONLI', &
                 'NB_PHYEQ', 'NB_STEPS', 'NL_BUFF ', 'NL_CASE ', 'NL_SAVE0', &
                 'NL_SAVE1', 'NL_TREAT', 'NUM_DDL ', 'N_ORD_VC', 'OMEGA   ', &
                 'OMEGA_SQ', 'RESU_SD ', 'RIGI_DIA', 'RIGI_FUL', 'RIGI_MAT', &
                 'RIGY_FUL', 'SCHEMA  ', 'SCHEMA_I', 'SD_NONL ', 'SOLVER  ', &
                 'SUB_STRU', 'TYP_BASE', 'VITE_VAR', 'V_ROT   ', 'V_ROT_F '/

    data partyp /'R  ', 'I  ', 'I  ', 'R  ', 'R  ', &
                 'K24', 'I  ', 'I  ', 'I  ', 'I  ', &
                 'R  ', 'K24', 'K24', 'R  ', 'K24', &
                 'R  ', 'I  ', 'R  ', 'R  ', 'R  ', &
                 'R  ', 'K24', 'R  ', 'I  ', 'R  ', &
                 'I  ', 'I  ', 'I  ', 'R  ', 'R  ', &
                 'R  ', 'R  ', 'K24', 'R  ', 'R  ', &
                 'K8 ', 'R  ', 'R  ', 'I  ', 'R  ', &
                 'R  ', 'R  ', 'R  ', 'I  ', 'R  ', &
                 'R  ', 'R  ', 'R  ', 'R  ', 'K24', &
                 'I  ', 'K24', 'I  ', 'I  ', 'I  ', &
                 'I  ', 'I  ', 'I  ', 'I  ', 'R  ', &
                 'R  ', 'I  ', 'K24', 'I  ', 'R  ', &
                 'R  ', 'K24', 'R  ', 'R  ', 'K24', &
                 'R  ', 'K24', 'I  ', 'K24', 'K24', &
                 'I  ', 'K24', 'K24', 'R  ', 'K24'/ 

! -------------------------------------------------------------------------
!   parind = -2 : vector global        ; = -1 : scalar global ;
!          =  2 : vector per occurence ; =  1 : scalar per occurence
! -------------------------------------------------------------------------

    data parind /-2, -1, -2, -2, -2, &
                 -1, -1, -1, -1, -2, &
                 -2, -1, -1, -2, -1, &
                 -2, -2, -1, -1, -1, &
                 -2, -1, -2, -1, -2, &
                 -2, -2, -2, -2, -2, &
                 -2, -2, -1, -1, -2, &
                 -2, -2, -2, -1, -2, &
                 -2, -2, -2, -2, -1, &
                 -1, -2, -2, -2, -1, &
                 -2, -1, -1, -1, -1, &
                 -1, -1, -2, -1, -2, &
                 -2, -1, -1, -2, -2, &
                 -2, -1, -2, -2, -1, &
                 -2, -1, -1, -1, -2, &
                 -1, -1, -1, -1, -1/
