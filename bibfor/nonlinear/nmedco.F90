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

subroutine nmedco(compor, option, imate, npg, lgpg,&
                  s, q, vim, vip, alphap,&
                  dalfs)
!
    implicit none
!
#include "asterfort/lcedex.h"
#include "asterfort/utmess.h"
    integer :: imate, npg, lgpg
    real(kind=8) :: s(2), q(2, 2), alphap(2), dalfs(2, 2)
    real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg)
    character(len=16) :: compor(*), option
!
! ----------------------------------------------------------------------
!     INTEGRATION DES LOIS DE COMPORTEMENT NON LINEAIRE POUR LES
!     ELEMENTS A DISCONTINUITE INTERNE.
!     LE COMPORTEMENT ETANT PARTICULIER, CETTE ROUTINE FAIT OFFICE DE
!     'NMCOMP.F' POUR DE TELS ELEMENTS.
!
!     REMARQUE : CETTE ROUTINE N'EST PAS DANS UNE BOULCE SUR LES PG CAR
!                LES VI SONT CONSTANTES SUR CHAQUE ELEMENT.
!-----------------------------------------------------------------------
! IN
!     NPG     : NOMBRE DE POINTS DE GAUSS
!     LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!     IMATE   : ADRESSE DU MATERIAU CODE
!     COMPOR  : COMPORTEMENT :  (1) = TYPE DE RELATION COMPORTEMENT
!                               (2) = NB VARIABLES INTERNES / PG
!                               (3) = HYPOTHESE SUR LES DEFORMATIONS
!     OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
!     VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
!     S,Q     : QUANTITES CINEMATIQUES NECESSAIRES POUR CALCUL DU SAUT
!
! OUT
!     ALPHAP  : SAUT A L'INSTANT PLUS
!     VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
!     DALFS   : DEVIVEE DU SAUT PAR RAPPORT A S
!
!-----------------------------------------------------------------------
!
    if (compor(1) .eq. 'CZM_EXP') then
!
        call lcedex(option, imate, npg, lgpg, s,&
                    q, vim, vip, alphap, dalfs)
!
    else
!
        call utmess('F', 'ALGORITH7_69', sk=compor(1))
    endif
!
end subroutine
