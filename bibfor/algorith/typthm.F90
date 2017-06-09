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

subroutine typthm(axi, perman, vf, typvf, typmod,&
                  ndim)
! OUT AXI    : .TRUE. OU .FALSE. SELON LE CARACTERE AXISYMETRIQUE DU PB
!
! OUT VF     : .TRUE. OU .FALSE. SELON LE CARACTERE VF OU PAS
!     VF EST VRAI SI LA FORMULATION CONTINUE EST UN BILAN PAR MAILLE
!               DONC VF EST VRAI POUR SUSHI OU TPFA
!               AVEC OU SANS PRISE EN COMPTE DES VOISINS
! OUT TYPVF TYPE DE VF :1 = TPFA (FLUX A DEUX POINTS - SCHEMA SUPPRIME)
!                    2  = SUSHI AVEC VOISIN DECENTRE MAILLE (SUDM - SUPPRIME)
!                    3  = SUSHI AVEC VOISIN DECENTRE ARETE (SUDA)
!                    4  = SUSHI AVEC VOISIN CENTRE  (SUC - SUPPRIME)
! OUT PERMAN : .TRUE. OU .FALSE. SELON LE CARACTERE AXISYMETRIQUE DE
!              LA PARTIE HYDRAULIQUE
! OUT TYPMOD : 1. TYPE DE MODELISATION : AXI/D_PLAN/3D
! OUT NDIM   : DIMENSION DU PROBLEME (2 OU 3)
! ----------------------------------------------------------------------
    implicit none
!
!     --- ARGUMENTS ---
#include "asterf_types.h"
#include "asterfort/lteatt.h"
#include "asterfort/lxlgut.h"
    aster_logical :: axi, perman, vf
    integer :: typvf
    integer :: ndim
    character(len=8) :: typmod(2)
!
!     --- VARIABLES LOCALES ---
!
!
! =====================================================================
! --- BUT : DETERMINER LE TYPE DE MODELISATION (AXI/D_PLAN/3D) --------
! =====================================================================
    axi = .false.
!
    if (lteatt('AXIS','OUI')) then
        axi = .true.
        typmod(1) = 'AXIS    '
        ndim = 2
!
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN  '
        ndim = 2
!
    else
        typmod(1) = '3D      '
        ndim = 3
    endif
!
! =====================================================================
! --- BUT : LA PARTIE HM EST-ELLE TRANSITOIRE OU PERMANENTE EN TEMPS ?
! =====================================================================
!
    if (lteatt('MODELI','DHB')) then
        perman = .true.
    else
        perman = .false.
    endif
!
!   -- MODELISATIONS SUSHI VOLUMES FINIS
    if (lteatt('MODELI','3AD').or.lteatt('MODELI','2DA')) then
        vf = .true.
        typvf=3
    else
        typvf =0
        vf = .false.
    endif
!
end subroutine
