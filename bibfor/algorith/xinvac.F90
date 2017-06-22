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

subroutine xinvac(elp, ndim, tabar, s, ksi)
    implicit none
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
    integer :: ndim
    real(kind=8) :: s, ksi(ndim), tabar(*)
    character(len=8) :: elp
!                      TROUVER LES PTS MILIEUX ENTRE LES EXTREMITES DE
!                      L'ARETE ET LE POINT D'INTERSECTION
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       TABAR   : COORDONNEES DES 3 NOEUDS DE L'ARETE
!       S       : ABSCISSE CURVILIGNE DU POINT SUR L'ARETE
!
!     SORTIE
!       XE      : COORDONNES DE REFERENCE DU POINT
!     ----------------------------------------------------------------
!
    real(kind=8) :: coef1, coef2, coef3, ptint(1)
    real(kind=8) :: pt1(3), pt2(3), pt3(3)
    real(kind=8) :: d, epsmax, tab(8, ndim)
    integer :: itemax, i
    character(len=6) :: name
!
!.....................................................................
!
!
    itemax=500
    epsmax=1.d-9
    name='XINVAC'
    ptint(1)=0.d0
!
!    CALCUL DE COEF1, COEF2, COEF3, D
    coef1=0.d0
    coef2=0.d0
    coef3=0.d0
    call vecini(ndim, 0.d0, pt1)
    call vecini(ndim, 0.d0, pt2)
    call vecini(ndim, 0.d0, pt3)
!
    do i = 1, ndim
        pt1(i)=tabar(i)
        pt2(i)=tabar(ndim+i)
        pt3(i)=tabar(2*ndim+i)
    end do
!
    do  i = 1, ndim
        coef1 = coef1 + (pt1(i)-2*pt3(i)+pt2(i))* (pt1(i)-2*pt3(i)+ pt2(i))
    end do
!
    do i = 1, ndim
        coef2 = coef2 + (pt2(i)-pt1(i))*(pt1(i)-2*pt3(i)+pt2(i))
    end do
!
    do  i = 1, ndim
        coef3 = coef3 + (pt2(i)-pt1(i))*(pt2(i)-pt1(i))/4
    end do
!
    d = coef2*coef2 - 4*coef1*coef3
!
!    CALCUL COORDONNEES DE REFERENCE DU POINT
!
    if (abs(coef1) .le. r8prem()) then
        ksi(1) = (s/sqrt(coef3))-1
    else if (abs(coef1).gt.r8prem()) then
        call utmess('F', 'XFEM_65')
    endif
!
end subroutine
