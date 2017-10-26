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

subroutine thmGetElemIntegration(l_vf, inte_type)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/teattr.h"
!
aster_logical, intent(in) :: l_vf
character(len=3), intent(out) :: inte_type
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get type of integration
!
! --------------------------------------------------------------------------------------------------
!
! In  l_vf             : flag for finite volume
! Out inte_type        : type of integration - classical, lumped (D), reduced (R)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_princ
    integer :: iret
    character(len=1) :: d1, d2
    character(len=3) :: mint
!
! --------------------------------------------------------------------------------------------------
!
    if (l_vf) then
        inte_type = 'CLA'
    else
        call teattr('S', 'DIM_TOPO_MODELI', d1, iret)
        call teattr('S', 'DIM_TOPO_MAILLE', d2, iret)
        l_princ   = (d1.eq.d2)
        inte_type = 'CLA'
        if (l_princ) then
            call teattr('C', 'INTTHM', mint, iret)
            if (iret .eq. 0) then
                inte_type = mint
            endif
        endif
    endif
!
end subroutine
