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
!
#define EVT_NB               7
#define EVT_ERROR            1
#define EVT_INCR_QUANT       2
#define EVT_COLLISION        3
#define EVT_INTERPENE        4
#define EVT_DIVE_RESI        5
#define EVT_INSTABILITY      6
#define EVT_RESI_MAXI        7
! Size of vectors
#define SIZE_LLINR           11
#define SIZE_LEEVR           7
#define SIZE_LEEVK           3
#define SIZE_LESUR           10
#define SIZE_LAEVR           6
#define SIZE_LAEVK           1
#define SIZE_LATPR           6
#define SIZE_LATPK           4

integer, parameter :: eventNbMaxi(EVT_NB)            = (/1, 99, 1,&
                                                         1, 99, 1,&
                                                         1/)

character(len=16), parameter :: eventKeyword(EVT_NB) = (/'ERREUR          ',&
                                                         'DELTA_GRANDEUR  ',&
                                                         'COLLISION       ',&
                                                         'INTERPENETRATION',&
                                                         'DIVE_RESI       ',&
                                                         'INSTABILITE     ',&
                                                         'RESI_MAXI       '/)
