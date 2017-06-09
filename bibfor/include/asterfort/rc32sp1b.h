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
    subroutine rc32sp1b(ze200, lieu, numsip, numsiq, seismeb32, seismeunit,&
                        seismeze200, mse, propi, propj, proqi, proqj,&
                        instsp, sp, spme, mat1, mat2)
        aster_logical :: ze200
        character(len=4) :: lieu
        integer :: numsip
        integer :: numsiq
        aster_logical :: seismeb32
        aster_logical :: seismeunit
        aster_logical :: seismeze200
        real(kind=8) :: mse(12)
        real(kind=8) :: propi(20)
        real(kind=8) :: propj(20)
        real(kind=8) :: proqi(20)
        real(kind=8) :: proqj(20)
        real(kind=8) :: instsp(4)
        real(kind=8) :: sp(2)
        real(kind=8) :: spme(2)
        real(kind=8) :: mat1(7)
        real(kind=8) :: mat2(7)
    end subroutine rc32sp1b
end interface
