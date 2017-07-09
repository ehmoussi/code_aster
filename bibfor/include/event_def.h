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
! person_in_charge: mickael.abbas at edf.fr
!
! Event define : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!
#include "asterf_types.h"
! Size of vectors
#define SIZE_LLINR           11
#define SIZE_LEEVR           7
#define SIZE_LEEVK           3
#define SIZE_LESUR           10
#define SIZE_LAEVR           6
#define SIZE_LAEVK           1
#define SIZE_LATPR           6
#define SIZE_LATPK           4
! Defines for ECHEC/EVENEMENT
#define FAIL_EVT_NB               7
#define FAIL_EVT_ERROR            1
#define FAIL_EVT_INCR_QUANT       2
#define FAIL_EVT_COLLISION        3
#define FAIL_EVT_INTERPENE        4
#define FAIL_EVT_DIVE_RESI        5
#define FAIL_EVT_INSTABILITY      6
#define FAIL_EVT_RESI_MAXI        7

integer, parameter :: failEventMaxi(FAIL_EVT_NB)     = (/1, 99, 1,&
                                                         1, 99, 1,&
                                                         1/)

character(len=16), parameter :: failEventKeyword(FAIL_EVT_NB) = (/'ERREUR          ',&
                                                                  'DELTA_GRANDEUR  ',&
                                                                  'COLLISION       ',&
                                                                  'INTERPENETRATION',&
                                                                  'DIVE_RESI       ',&
                                                                  'INSTABILITE     ',&
                                                                  'RESI_MAXI       '/)

! Defines for ECHEC/ACTION
#define FAIL_ACT_NB               6
#define FAIL_ACT_STOP             1
#define FAIL_ACT_CUT              2
#define FAIL_ACT_ITER             3
#define FAIL_ACT_PILOTAGE         4
#define FAIL_ACT_ADAPT_COEF       5
#define FAIL_ACT_CONTINUE         6

character(len=16), parameter :: failActionKeyword(FAIL_ACT_NB) = (/'ARRET           ',&
                                                                   'DECOUPE         ',&
                                                                   'ITER_SUPPL      ',&
                                                                   'AUTRE_PILOTAGE  ',&
                                                                   'ADAPT_COEF_PENA ',&
                                                                   'CONTINUE        '/)
! Defines for ADAPTATION/EVENEMENT
#define ADAP_EVT_NB               3
#define ADAP_EVT_NONE             1
#define ADAP_EVT_ALLSTEPS         2
#define ADAP_EVT_TRIGGER          3

character(len=16), parameter :: adapEventKeyword(ADAP_EVT_NB) = (/'AUCUN           ',&
                                                                  'TOUT_INST       ',&
                                                                  'SEUIL           '/)

! Defines for ADAPTATION/MODE_CALCUL_TPLUS
#define ADAP_ACT_NB               4
#define ADAP_ACT_FIXE             1
#define ADAP_ACT_INCR_QUANT       2
#define ADAP_ACT_ITER             3
#define ADAP_ACT_IMPLEX           4

character(len=16), parameter :: adapActionKeyword(ADAP_ACT_NB) = (/'FIXE            ',&
                                                                   'DELTA_GRANDEUR  ',&
                                                                   'ITER_NEWTON     ',&
                                                                   'IMPLEX          '/)
