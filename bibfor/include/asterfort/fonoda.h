! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface 
    subroutine fonoda(ds_thm  ,&
                      jv_mater, ndim  , l_steady, fnoevo,&
                      mecani  , press1, press2  , tempe ,&
                      dimdef  , dimcon, dt      , congem,&
                      r)
        use THM_type
        type(THM_DS), intent(in) :: ds_thm
        integer, intent(in) :: jv_mater
        integer, intent(in) :: ndim
        aster_logical, intent(in) :: fnoevo
        aster_logical, intent(in) :: l_steady
        integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
        integer, intent(in) :: dimdef, dimcon
        real(kind=8), intent(in) :: dt
        real(kind=8), intent(inout) :: congem(dimcon)
        real(kind=8), intent(out) :: r(dimdef+1)
    end subroutine fonoda
end interface 
