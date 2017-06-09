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

subroutine dfdm1d(nno, poids, dfrdk, coor, dfdx,&
                  cour, jacp, cosa, sina)
    implicit none
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    integer :: nno
    real(kind=8) :: dfrdk(1), coor(*), dfdx(1)
    real(kind=8) :: dxdk, dydk, cour, jac, jacp, poids, sina, cosa
! ......................................................................
!    - BUTS:  CALCULER LA VALEUR DU POIDS D'INTEGRATION EN 1 POINT DE
!             GAUSS POUR UN SEGMENT PLAN
!      + CALCULE LE SINUS ET LE COSIMUS DE L'ANGLE ENTRE LA NORMALE
!        ET L'AXE OX
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
!                     COUR          <--  COURBURE AU NOEUD
!                     COSA          <--  COS DE L'ANGLE ALPHA:
!                                        NORMALE / HORIZONTALE
!                     SINA          <--  SIN DE L'ANGLE ALPHA
!                     JACP          <--  PRODUIT DU JACOBIEN ET DU POIDS
!
!  REMARQUE :
!    - LES SEGMENTS DOIVENT ETRE CONTENUS DANS UN PLAN (DANS OXY)
!
    character(len=8) :: nomail
    integer :: i
!
!-----------------------------------------------------------------------
    integer :: iadzi, iazk24
    real(kind=8) :: d2xdk, d2ydk
!-----------------------------------------------------------------------
    dxdk = 0.d0
    dydk = 0.d0
    do 100 i = 1, nno
        dxdk = dxdk + coor( 2*i-1 ) * dfrdk(i)
        dydk = dydk + coor( 2*i ) * dfrdk(i)
100 continue
    jac = sqrt ( dxdk**2 + dydk**2 )
!
    if (abs(jac) .le. 1.d0/r8gaem()) then
        call tecael(iadzi, iazk24)
        nomail= zk24(iazk24-1+3)(1:8)
        call utmess('F', 'ALGORITH2_59', sk=nomail)
    endif
!
    cosa = dydk/jac
    sina = -dxdk/jac
    d2xdk = coor(1) + coor(3) - 2.d0 * coor(5)
    d2ydk = coor(2) + coor(4) - 2.d0 * coor(6)
    cour = ( dxdk * d2ydk - d2xdk * dydk ) / jac**3
    do 200 i = 1, nno
        dfdx(i) = dfrdk(i) / jac
200 continue
    jacp = jac * poids
end subroutine
