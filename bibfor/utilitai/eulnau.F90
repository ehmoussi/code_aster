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

subroutine eulnau(angeul, angnau)
    implicit none
!     PASSAGE DES ANGLES D'EULER AUX ANGLES NAUTIQUES
!     IN : ANGEUL(3) : 3 ANGLES D'EULER EN DEGRES
!     OUT : ANGNAU(3) : 3 ANGLES NAUTIQUES EN DEGRES
!
#include "asterc/r8dgrd.h"
#include "asterc/r8pi.h"
#include "asterfort/angvxy.h"
    real(kind=8) :: angnau(3), pe(3, 3), angeul(3)
    real(kind=8) :: costhe
    real(kind=8) :: xg(3), yg(3), cosphi, phi, sinphi, sinthe
    real(kind=8) :: psi, theta, cospsi, sinpsi
    integer :: i
!
    psi  =angeul(1)*r8dgrd()
    theta=angeul(2)*r8dgrd()
    phi  =angeul(3)*r8dgrd()
    cosphi=cos(phi)
    cospsi=cos(psi)
    costhe=cos(theta)
    sinphi=sin(phi)
    sinpsi=sin(psi)
    sinthe=sin(theta)
!
!     MATRICE ROTATION ASSOCIEE AUX ANGLES D'EULER
    pe(1,1)= cosphi *cospsi - sinphi *costhe *sinpsi
    pe(2,1)= cosphi *sinpsi + sinphi *costhe *cospsi
    pe(3,1)= sinphi *sinthe
    pe(1,2)= -sinphi *cospsi - cosphi *costhe *sinpsi
    pe(2,2)= -sinphi *sinpsi + cosphi *costhe *cospsi
    pe(3,2)= cosphi *sinthe
    pe(1,3)= sinthe *sinpsi
    pe(2,3)= -sinthe *cospsi
    pe(3,3)= costhe
!     EXPRESSION DES VECTEURS DE LA BASE LOCALE DANS LE REPERE LOCAL
    do 1 i = 1, 3
        xg(i)=pe(i,1)
        yg(i)=pe(i,2)
!         ZG(I)=PE(I,3)
 1  end do
!
    call angvxy(xg, yg, angnau)
!
    if (angnau(1) .lt. 0.d0) angnau(1)=angnau(1)+2.0d0*r8pi()
    if (angnau(2) .lt. 0.d0) angnau(2)=angnau(2)+2.0d0*r8pi()
    if (angnau(3) .lt. 0.d0) angnau(3)=angnau(3)+2.0d0*r8pi()
!
    angnau(1)=angnau(1)/r8dgrd()
    angnau(2)=angnau(2)/r8dgrd()
    angnau(3)=angnau(3)/r8dgrd()
!
!
end subroutine
