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
    subroutine hujmid(mod, crit, mater, nvi, deps,&
                      sigd, sigf, vind, vinf, noconv,&
                      aredec, stopnc, negmul, iret, subd,&
                      loop, ndec0, indi, mectra)
        character(len=8) :: mod
        real(kind=8) :: crit(*)
        real(kind=8) :: mater(22, 2)
        integer :: nvi
        real(kind=8) :: deps(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vind(*)
        real(kind=8) :: vinf(*)
        aster_logical :: noconv
        aster_logical :: aredec
        aster_logical :: stopnc
        aster_logical :: negmul(8)
        integer :: iret
        aster_logical :: subd
        aster_logical :: loop
        integer :: ndec0
        integer :: indi(7)
        aster_logical :: mectra
    end subroutine hujmid
end interface
