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
    subroutine mecalr(newcal, tysd, knum, kcha, resuco,&
                      resuc1, nbordr, modele, mate, cara,&
                      nchar, ctyp)
        aster_logical :: newcal
        character(len=16) :: tysd
        character(len=19) :: knum
        character(len=19) :: kcha
        character(len=8) :: resuco
        character(len=8) :: resuc1
        integer :: nbordr
        character(len=8) :: modele
        character(len=24) :: mate
        character(len=8) :: cara
        integer :: nchar
        character(len=4) :: ctyp
    end subroutine mecalr
end interface
