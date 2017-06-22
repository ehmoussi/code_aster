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

subroutine scalff(nbfonc, nbp, disc, vale, a)
    implicit none
!     CALCUL DES PRODUITS SCALAIRES ENTRE LES FONCTIONS DE FORME
!     APPELANT : SPECFF
!-----------------------------------------------------------------------
! IN  : NBFONC : NOMBRE DE FONCTIONS
! IN  : NBP    : NOMBRE DE POINTS DE DISCRETISATION DES FONCTIONS
! IN  : DISC   : DISCRETISATION SUR LAQUELLE SONT CALCULEES LES
!                INTEGRALES DONNANT LES PRODUITS SCALAIRES  - DIM : NBP
! IN  : VALE   : TABLEAU DES VALEURS DES FONCTIONS  - DIM : (NBP,NBFONC)
! OUT : A      : MATRICE DES PRODUITS SCALAIRES  - DIM : (NBFONC,NBFONC)
!
!
#include "jeveux.h"
    integer :: nbfonc, nbp
    real(kind=8) :: disc(nbp), vale(nbp, nbfonc), a(nbfonc, nbfonc)
    integer :: ifo1, ifo2, ip
    real(kind=8) :: dx, y1, y2, yy
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
!-----1.CALCUL DES TERMES DU TRIANGLE INFERIEUR
!
    do 10 ifo2 = 1, nbfonc
!
        do 11 ifo1 = ifo2, nbfonc
!
            a(ifo1,ifo2) = 0.d0
            do 12 ip = 1, nbp-1
                dx = disc(ip+1) - disc(ip)
                y1 = vale(ip,ifo1)*vale(ip,ifo2)
                y2 = vale(ip+1,ifo1)*vale(ip+1,ifo2)
                yy = y1 + y2
                a(ifo1,ifo2) = a(ifo1,ifo2) + yy * dx
12          continue
            a(ifo1,ifo2) = a(ifo1,ifo2)/2.d0
!
11      continue
!
10  end do
!
!-----2.DEDUCTION DES TERMES DU TRIANGLE SUPERIEUR PAR SYMETRIE
!
    if (nbfonc .gt. 1) then
!
        do 20 ifo2 = 2, nbfonc
            do 21 ifo1 = 1, ifo2-1
                a(ifo1,ifo2) = a(ifo2,ifo1)
21          continue
20      continue
!
    endif
!
end subroutine
