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
    subroutine utintc(zrino2, zrino1, zrjno2, zrjno1, x3,&
                      y3, inst, insold, k8cart, ltheta,&
                      nsomm, valfp, valfm, ifm, niv,&
                      option)
        real(kind=8) :: zrino2
        real(kind=8) :: zrino1
        real(kind=8) :: zrjno2
        real(kind=8) :: zrjno1
        real(kind=8) :: x3
        real(kind=8) :: y3
        real(kind=8) :: inst
        real(kind=8) :: insold
        character(len=8) :: k8cart
        aster_logical :: ltheta
        integer :: nsomm
        real(kind=8) :: valfp(9)
        real(kind=8) :: valfm(9)
        integer :: ifm
        integer :: niv
        integer :: option
    end subroutine utintc
end interface
