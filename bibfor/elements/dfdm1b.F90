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

subroutine dfdm1b(nno, poids, dfrdk, coor, dfdx,&
                  jacp)
    implicit none
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    integer :: nno
    real(kind=8) :: dfrdk(1), coor(*), dfdx(1)
    real(kind=8) :: jacp, poids
! ......................................................................
!    - BUTS:  CALCULER LA VALEUR DU POIDS D'INTEGRATION EN 1 POINT DE
!             GAUSS POUR UN SEGMENT PLONGE DANS LE 3D
!      + CALCULE LES DERIVEES DES FONCTIONS DE FORME DANS L'ELEMENT REEL
!
!    - ARGUMENTS:
!        DONNEES:     NNO           -->  NOMBRE DE NOEUDS
!                     POIDS         -->  POIDS DE GAUSS
!                     DFRDK         -->  DERIVEES FONCTIONS DE FORME
!                     COOR          -->  COORDONNEES DES NOEUDS
!
!        RESULTATS:   DFDX          <--  DERIVEES DES FONCTIONS DE FORME
!                                        / ABSCISSE CURVILIGNE
!                     JACP          <--  PRODUIT DU JACOBIEN ET DU POIDS
!
!-----------------------------------------------------------------------
    character(len=8) :: nomail
    integer :: iadzi, iazk24, i
    real(kind=8) :: jac, dxdk, dydk, dzdk
!-----------------------------------------------------------------------
    dxdk = 0.d0
    dydk = 0.d0
    dzdk = 0.d0
    do i = 1, nno
        dxdk = dxdk + coor( 3*i-2 ) * dfrdk(i)
        dydk = dydk + coor( 3*i-1 ) * dfrdk(i)
        dzdk = dzdk + coor( 3*i ) * dfrdk(i)
    end do
    jac = sqrt ( dxdk**2 + dydk**2 +dzdk**2)
!
    if (abs(jac) .le. 1.d0/r8gaem()) then
        call tecael(iadzi, iazk24)
        nomail= zk24(iazk24-1+3)(1:8)
        call utmess('F', 'ALGORITH2_59', sk=nomail)
    endif
!
    do i = 1, nno
        dfdx(i) = dfrdk(i) / jac
    end do
    jacp = jac * poids
end subroutine
