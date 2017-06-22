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
    subroutine assma2(ldistme, lmasym, tt, nu14, ncmp, matel,&
                      c1, jvalm, jtmp2, lgtmp2)
        aster_logical, intent(in) :: ldistme, lmasym
        character(len=2), intent(in) :: tt
        character(len=14), intent(in) :: nu14
        integer, intent(in) :: ncmp
        character(len=19), intent(in) :: matel
        real(kind=8), intent(in) :: c1
        integer :: jvalm(2)
        integer :: jtmp2
        integer :: lgtmp2
    end subroutine assma2
end interface
