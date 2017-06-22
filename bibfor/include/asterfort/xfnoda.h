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
    subroutine xfnoda(imate, mecani, press1, enrmec, dimenr,&
                      dimcon, ndim, dt, fnoevo, congem,&
                      r, enrhyd, nfh)
        integer :: dimcon
        integer :: dimenr
        integer :: imate
        integer :: mecani(5)
        integer :: press1(7)
        integer :: enrmec(3)
        integer :: ndim
        real(kind=8) :: dt
        aster_logical :: fnoevo
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: r(dimenr)
        integer :: enrhyd(3)
        integer :: nfh
    end subroutine xfnoda
end interface 
