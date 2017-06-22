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
    subroutine gbilin(fami, kp, imate, dudm, dvdm,&
                  dtdm, dfdm, tgdm, poids, sigin,&
                  dsigin, epsref, c1,&
                  c2, c3, cs, th, coef,&
                  rho, puls, axi, g)
        character(len=*) :: fami
        integer :: kp
        integer :: imate
        real(kind=8) :: dudm(3, 4)
        real(kind=8) :: dvdm(3, 4)
        real(kind=8) :: dtdm(3, 4)
        real(kind=8) :: dfdm(3, 4)
        real(kind=8) :: tgdm(2)
        real(kind=8) :: poids
        real(kind=8) :: sigin(6)
        real(kind=8) :: dsigin(6,3)
        real(kind=8) :: epsref(6)
        real(kind=8) :: c1
        real(kind=8) :: c2
        real(kind=8) :: c3
        real(kind=8) :: cs
        real(kind=8) :: th
        real(kind=8) :: coef
        real(kind=8) :: rho
        real(kind=8) :: puls
        aster_logical :: axi
        real(kind=8) :: g
    end subroutine gbilin
end interface
