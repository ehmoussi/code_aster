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
    subroutine mmmsta(ndim, leltf, lpenaf, loptf, djeut,&
                      dlagrf, coefaf,  tau1, tau2,&
                      lcont, ladhe, lambda, rese, nrese, l_previous)
        integer, intent(in) :: ndim
        aster_logical, intent(out) :: leltf
        aster_logical, intent(out) :: lpenaf
        aster_logical, intent(in) :: loptf
        aster_logical, intent(in) :: l_previous
        real(kind=8), intent(in)  :: djeut(3)
        real(kind=8), intent(in)  :: dlagrf(2)
        real(kind=8), intent(in)   :: coefaf
        real(kind=8), intent(in) :: tau1(3)
        real(kind=8), intent(in) :: tau2(3)
        aster_logical, intent(out)  :: lcont
        aster_logical, intent(out) :: ladhe
        real(kind=8), intent(in)   :: lambda
        real(kind=8), intent(out)  :: rese(3)
        real(kind=8), intent(out)  :: nrese
    end subroutine mmmsta
end interface
