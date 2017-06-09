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
    subroutine optimw(method, nrupt, x, y, prob,&
                      sigw, nt, nur, nbres, calm,&
                      cals, mk, sk, mkp, skp,&
                      impr, ifm, dept, indtp, nbtp)
        character(len=16) :: method
        integer :: nrupt
        real(kind=8) :: x(*)
        real(kind=8) :: y(*)
        real(kind=8) :: prob(*)
        real(kind=8) :: sigw(*)
        integer :: nt(*)
        integer :: nur(*)
        integer :: nbres
        aster_logical :: calm
        aster_logical :: cals
        real(kind=8) :: mk
        real(kind=8) :: sk(*)
        real(kind=8) :: mkp
        real(kind=8) :: skp(*)
        aster_logical :: impr
        integer :: ifm
        aster_logical :: dept
        integer :: indtp(*)
        integer :: nbtp
    end subroutine optimw
end interface
