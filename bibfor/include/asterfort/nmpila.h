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
    subroutine nmpila(numedd, sdpilo, isxfe, dtau, depdel,&
                      ddepl0, ddepl1, nbeffe, eta, pilcvg)
        character(len=24) :: numedd
        character(len=19) :: sdpilo
        aster_logical :: isxfe
        real(kind=8) :: dtau
        character(len=19) :: depdel
        character(len=19) :: ddepl0
        character(len=19) :: ddepl1
        integer :: nbeffe
        real(kind=8) :: eta(2)
        integer :: pilcvg
    end subroutine nmpila
end interface
