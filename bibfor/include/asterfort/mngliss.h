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
    subroutine mngliss(ndim     , kappa    ,&
                       tau1     , tau2     ,&
                       taujeu1  , taujeu2  ,&
                       dnepmait1, dnepmait2,&
                       djeut)
        integer, intent(in) :: ndim
        real(kind=8), intent(in):: kappa(2,2)
        real(kind=8), intent(in) :: tau1(3), tau2(3)
        real(kind=8), intent(in) :: taujeu1, taujeu2
        real(kind=8), intent(in) :: dnepmait1, dnepmait2
        real(kind=8), intent(out) ::  djeut(3)
    end subroutine mngliss
end interface
