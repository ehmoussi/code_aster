! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rsGetSize(resultName, resultSize)
!
implicit none
!
#include "asterfort/rsorac.h"
!
character(len=8), intent(in) :: resultName
integer, intent(out) :: resultSize
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get size results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! Out resultSize       : size of results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: k8bid
    complex(kind=8) :: c16bid
    integer :: list(1), iret
    real(kind=8) :: r8bid
!
! --------------------------------------------------------------------------------------------------
!
    resultSize = 0
    call rsorac(resultName, 'LONMAX', 0  , r8bid, k8bid,&
                c16bid    , 0.d0     , ' ', list , 1    ,&
                iret)
    resultSize = list(1)
!
end subroutine
