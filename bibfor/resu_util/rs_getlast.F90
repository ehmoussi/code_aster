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

subroutine rs_getlast(result_, nume_last, inst_last)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsorac.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    integer, intent(out) :: nume_last
    real(kind=8), optional, intent(out) :: inst_last
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get last index stored in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! Out nume_last        : last index stored in results datastructure
! Out inst_last        : last time stored in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result
    character(len=8) :: k8bid
    complex(kind=8) :: c16bid
    integer :: list(1), iret, jinst
    real(kind=8) :: r8bid
!
! --------------------------------------------------------------------------------------------------
!
    result    = result_
    nume_last = 0
    call rsorac(result, 'DERNIER', 0  , r8bid, k8bid,&
                c16bid, 0.d0     , ' ', list , 1    ,&
                iret)
    if (iret .eq. 1) then
        nume_last = list(1)
    endif
    if (present(inst_last)) then
        call rsadpa(result, 'L', 1, 'INST', nume_last,&
                    0, sjv=jinst)
        inst_last = zr(jinst)
    endif

end subroutine
