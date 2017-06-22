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
    subroutine ar_ztrevc(side, howmny, select, n, t,&
                      ldt, vl, ldvl, vr, ldvr,&
                      mm, m, work, rwork, info)
        integer :: ldvr
        integer :: ldvl
        integer :: ldt
        character(len=1) :: side
        character(len=1) :: howmny
        aster_logical :: select(*)
        integer :: n
        complex(kind=8) :: t(ldt, *)
        complex(kind=8) :: vl(ldvl, *)
        complex(kind=8) :: vr(ldvr, *)
        integer :: mm
        integer :: m
        complex(kind=8) :: work(*)
        real(kind=8) :: rwork(*)
        integer :: info
    end subroutine ar_ztrevc
end interface
