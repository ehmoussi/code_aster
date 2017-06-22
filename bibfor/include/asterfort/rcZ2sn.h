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
    subroutine rcZ2sn(ze200, lieu, numsip, numsiq, iocs, mse,&
                      propi, propj, proqi, proqj, instsn, sn,&
                      sp3, spmeca3, snet, trescapr, tresth)
        aster_logical :: ze200
        character(len=4) :: lieu
        integer :: numsip
        integer :: numsiq
        integer :: iocs
        real(kind=8) :: mse(12)
        real(kind=8) :: propi(20)
        real(kind=8) :: propj(20)
        real(kind=8) :: proqi(20)
        real(kind=8) :: proqj(20)
        real(kind=8) :: instsn(2)
        real(kind=8) :: sn
        real(kind=8) :: sp3
        real(kind=8) :: spmeca3
        real(kind=8) :: snet
        real(kind=8) :: trescapr
        real(kind=8) :: tresth
    end subroutine rcZ2sn
end interface
