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

subroutine scaldf(nbfonc, nbp, nbmr, disc, vale,&
                  defm, b)
    implicit none
!     CALCUL DES PRODUITS SCALAIRES ENTRE LES DEFORMEES MODALES ET LES
!     FONCTIONS DE FORME ASSOCIEES A L'EXCITATION
!     APPELANT : SPECFF
!-----------------------------------------------------------------------
! IN  : NBFONC : NOMBRE DE FONCTIONS DE FORME ASSOCIEES A L'EXCITATION
! IN  : NBP    : NOMBRE DE POINTS DE DISCRETISATION DES FONCTIONS DE
!                FORME SUR L'INTERVALLE 0,2L
! IN  : NBMR   : NOMBRE DE MODES PRIS EN COMPTE
! IN  : DISC   : DISCRETISATION SUR LAQUELLE SONT CALCULEES LES
!                INTEGRALES DONNANT LES PRODUITS SCALAIRES
!                DIMENSION NBP
! IN  : VALE   : TABLEAU DES VALEURS DES FONCTIONS DE FORME (NBP,NBFONC)
! IN  : DEFM   : TABLEAU DES VALEURS DES DEFORMEES MODALES (NBP,NBMR)
! OUT : B      : MATRICE DES PRODUITS SCALAIRES (NBFONC,NBMR)
!
!
#include "jeveux.h"
    integer :: nbfonc, nbp, nbmr
    real(kind=8) :: disc(nbp), vale(nbp, nbfonc), defm(nbp, nbmr)
    real(kind=8) :: b(nbfonc, nbmr)
    integer :: ifo, imr, ip
    real(kind=8) :: dx, y1, y2, yy
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
    do 10 imr = 1, nbmr
        do 20 ifo = 1, nbfonc
            b(ifo,imr) = 0.d0
            do 30 ip = 1, nbp-1
                dx = disc(ip+1) - disc(ip)
                y1 = vale(ip,ifo)*defm(ip,imr)
                y2 = vale(ip+1,ifo)*defm(ip+1,imr)
                yy = y1 + y2
                b(ifo,imr) = b(ifo,imr) + yy * dx
30          continue
            b(ifo,imr) = b(ifo,imr)/2.d0
20      continue
10  end do
end subroutine
