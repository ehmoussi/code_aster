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
    subroutine pjxxco(typcal, method, lcorre, isole, resuin,&
                      cham1, moa1, moa2, noma1, noma2,&
                      cnref, noca)
        character(len=4) :: typcal
        character(len=19) :: method
        character(len=16) :: lcorre(2)
        aster_logical :: isole
        character(len=8) :: resuin
        character(len=19) :: cham1
        character(len=8) :: moa1
        character(len=8) :: moa2
        character(len=8) :: noma1
        character(len=8) :: noma2
        character(len=8) :: cnref
        character(len=8) :: noca
    end subroutine pjxxco
end interface
