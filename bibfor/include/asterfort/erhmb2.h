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
!
#include "asterf_types.h"
!
interface 
    subroutine erhmb2(perman, ino, nbs, ndim, theta,&
                      instpm, jac, nx, ny, tx,&
                      ty, nbcmp, geom, ivois, sielnp,&
                      sielnm, adsip, iagd, tbref2, iade2,&
                      iava2, ncmpm2, iaptm2, iade3, iava3,&
                      ncmpm3, iaptm3, tm2h1b)
        integer :: ndim
        aster_logical :: perman
        integer :: ino
        integer :: nbs
        real(kind=8) :: theta
        real(kind=8) :: instpm(2)
        real(kind=8) :: jac(3)
        real(kind=8) :: nx(3)
        real(kind=8) :: ny(3)
        real(kind=8) :: tx(3)
        real(kind=8) :: ty(3)
        integer :: nbcmp
        real(kind=8) :: geom(ndim, *)
        integer :: ivois
        real(kind=8) :: sielnp(140)
        real(kind=8) :: sielnm(140)
        integer :: adsip
        integer :: iagd
        integer :: tbref2(12)
        integer :: iade2
        integer :: iava2
        integer :: ncmpm2
        integer :: iaptm2
        integer :: iade3
        integer :: iava3
        integer :: ncmpm3
        integer :: iaptm3
        real(kind=8) :: tm2h1b(3)
    end subroutine erhmb2
end interface 
