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
!
subroutine testExternalBehaviour(carcri, l_mfront, l_umat)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
!
real(kind=8), intent(in) :: carcri(*)
aster_logical, intent(out) :: l_mfront, l_umat
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Test if the behaviour is external (mfront or umat)
!
! --------------------------------------------------------------------------------------------------
!
! In  carcri           : parameters for comportment
! Out l_mfront         : logical for mfront behaviour
! Out l_umat           : logical for umat behaviour
!
! --------------------------------------------------------------------------------------------------
!
    l_mfront = ASTER_FALSE
    l_umat = ASTER_FALSE
!
    if (nint(carcri(EXTE_PTR)) .ne. 0) then
        if (nint(carcri(EXTE_ESVA_PTR_NAME)) .ne. 0) then
            l_mfront = ASTER_TRUE
        else
            l_umat = ASTER_TRUE
        endif
    endif
!    
end subroutine
