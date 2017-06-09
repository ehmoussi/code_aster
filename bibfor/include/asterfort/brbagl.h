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
    subroutine brbagl(zimat, nmnbn, nmplas, nmdpla, nmddpl,&
                      nmzef, nmzeg, nmief, nmprox, depsp,&
                      ddissi, dc1, dc2, dtg, bbok,&
                      normm, normn)
        integer :: zimat
        real(kind=8) :: nmnbn(6)
        real(kind=8) :: nmplas(2, 3)
        real(kind=8) :: nmdpla(2, 2)
        real(kind=8) :: nmddpl(2, 2)
        real(kind=8) :: nmzef
        real(kind=8) :: nmzeg
        integer :: nmief
        integer :: nmprox(2)
        real(kind=8) :: depsp(6)
        real(kind=8) :: ddissi
        real(kind=8) :: dc1(6, 6)
        real(kind=8) :: dc2(6, 6)
        real(kind=8) :: dtg(6, 6)
        aster_logical :: bbok
        real(kind=8) :: normm
        real(kind=8) :: normn
    end subroutine brbagl
end interface
