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
    subroutine fcweib(nrupt, cals, sk, sigw, nur,&
                      nt, nbres, indtp, nbtp, m,&
                      fc, dfc)
        integer :: nrupt
        aster_logical :: cals
        real(kind=8) :: sk(*)
        real(kind=8) :: sigw(*)
        integer :: nur(*)
        integer :: nt(*)
        integer :: nbres
        integer :: indtp(*)
        integer :: nbtp
        real(kind=8) :: m
        real(kind=8) :: fc
        real(kind=8) :: dfc
    end subroutine fcweib
end interface
