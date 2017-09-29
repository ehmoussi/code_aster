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
    subroutine thmComputeMatrix(parm_theta, gravity,&
                                ndim      ,&
                                dimdef    , dimcon ,&
                                mecani    , press1 , press2, tempe,&
                                congem    , congep ,&
                                time_incr ,&
                                drds      )
        real(kind=8), intent(in)  :: parm_theta, gravity(3)
        integer, intent(in) :: ndim
        integer, intent(in) :: dimdef, dimcon
        integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
        real(kind=8), intent(in) :: congem(dimcon), congep(dimcon)
        real(kind=8), intent(in) :: time_incr
        real(kind=8), intent(out) :: drds(dimdef+1, dimcon)
    end subroutine thmComputeMatrix
end interface
