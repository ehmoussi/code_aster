! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mmmsta(ndim         , leltf         , indco ,&
                      ialgoc       , ialgof        ,&
                      lpenaf       , coefaf        ,&
                      lambda       , djeut         , dlagrf,&
                      tau1         , tau2          ,&
                      lcont        , ladhe         , l_fric_no,&
                      rese         , nrese         ,&
                      l_previous_  , indco_prev_   ,&
                      indadhe_prev_, indadhe2_prev_)
        integer, intent(in)  :: ndim
        aster_logical, intent(in) :: leltf
        integer, intent(in) :: ialgoc, ialgof, indco
        aster_logical, intent(in) :: lpenaf
        real(kind=8), intent(in) :: coefaf, lambda
        real(kind=8), intent(in) :: djeut(3), dlagrf(2)
        real(kind=8), intent(in)  :: tau1(3), tau2(3)
        aster_logical, intent(out) :: lcont, ladhe, l_fric_no
        real(kind=8), intent(out) :: rese(3), nrese
        aster_logical, optional, intent(in) :: l_previous_
        integer, optional, intent(in) :: indco_prev_, indadhe_prev_, indadhe2_prev_
    end subroutine mmmsta
end interface
