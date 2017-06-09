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

subroutine dfda2d(kpg, nno, poids, sdfrde, sdfrdk,&
                  sdedx, sdedy, sdkdx, sdkdy, sdfdx,&
                  sdfdy, geom, jac)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    integer :: nno
    real(kind=8) :: poids, sdfrde(4, 4), sdfrdk(4, 4)
    real(kind=8) :: geom(2, 4), jac
!
    integer :: i, kpg, iadzi, iazk24
    real(kind=8) :: sdxde, sdxdk, sdyde, sdydk
    real(kind=8) :: sdedx(4), sdkdx(4), sdkdy(4), sdedy(4)
    real(kind=8) :: sdfdy(4, 4), sdfdx(4, 4)
    character(len=8) :: nomail
!
!
!
!
!
!
    sdxde = 0.d0
    sdxdk = 0.d0
    sdyde = 0.d0
    sdydk = 0.d0
!
    do 10 i = 1, nno
        sdxde = sdxde + geom(1,i)*sdfrde(kpg,i)
        sdxdk = sdxdk + geom(1,i)*sdfrdk(kpg,i)
        sdyde = sdyde + geom(2,i)*sdfrde(kpg,i)
        sdydk = sdydk + geom(2,i)*sdfrdk(kpg,i)
10  end do
!
    jac = sdxde*sdydk - sdxdk*sdyde
!
    if (abs(jac) .le. 1.d0/r8gaem()) then
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        call utmess('F', 'ALGORITH2_59', sk=nomail)
    endif
!
    do 20 i = 1, nno
        sdfdx(kpg,i) = (sdydk*sdfrde(kpg,i)-sdyde*sdfrdk(kpg,i))/jac
        sdfdy(kpg,i) = (sdxde*sdfrdk(kpg,i)-sdxdk*sdfrde(kpg,i))/jac
20  end do
!
    sdedx(kpg) = sdydk/jac
    sdkdy(kpg) = sdxde/jac
    sdedy(kpg) = -sdxdk/jac
    sdkdx(kpg) = -sdyde/jac
    jac = abs(jac)*poids
!
end subroutine
