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
#include "asterf_types.h"
!
interface
    subroutine elg_resoud(matas1, matpre,  nsecm, chsecm, chsolu,&
                          base, rsolu, csolu, criter, prepos,&
                          istop, iret)
    character(len=19), intent(in) :: matas1
    character(len=*), intent(in) :: matpre
    integer, intent(in) :: nsecm
    character(len=*), intent(in) :: chsecm
    character(len=*), intent(in) :: chsolu
    character(len=*), intent(in) :: base
    real(kind=8), intent(inout) :: rsolu(*)
    complex(kind=8), intent(inout) :: csolu(*)
    character(len=*), intent(in) :: criter
    aster_logical, intent(in) :: prepos
    integer, intent(in) :: istop
    integer, intent(out) :: iret
    end subroutine elg_resoud
end interface
