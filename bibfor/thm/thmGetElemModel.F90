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
subroutine thmGetElemModel()
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get model of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret1, iret2
    real(kind=8) :: r8bid
!
! --------------------------------------------------------------------------------------------------
!
    ds_thm%ds_elem%l_dof_ther  = lteatt('THER','OUI')
    ds_thm%ds_elem%l_dof_meca  = lteatt('MECA','OUI')
    ds_thm%ds_elem%l_dof_hydr1 = .not. lteatt('HYDR1','0')
    ds_thm%ds_elem%l_dof_hydr2 = .not. lteatt('HYDR2','0')
    if (lteatt('HYDR1','1')) then
       ds_thm%ds_elem%nb_phase(1) = 1
    endif
    if (lteatt('HYDR1','2')) then
       ds_thm%ds_elem%nb_phase(1) = 2
    endif
    if (lteatt('HYDR2','1')) then
       ds_thm%ds_elem%nb_phase(2) = 1
    endif
    if (lteatt('HYDR2','2')) then
       ds_thm%ds_elem%nb_phase(2) = 2
    endif
!
! - Weak coupling
!
    call rcvarc(' ', 'DIVU', '-', 'RIGI', 1, 1, r8bid, iret1)
    call rcvarc(' ', 'DIVU', '+', 'RIGI', 1, 1, r8bid, iret2)
    ds_thm%ds_elem%l_weak_coupling = (iret1.eq.0) .and. (iret2.eq.0)
    if ((ds_thm%ds_elem%l_dof_meca) .and. ds_thm%ds_elem%l_weak_coupling) then
        call utmess('F', 'CHAINAGE_1')
    endif
    if ((ds_thm%ds_elem%l_weak_coupling) .and. (iret1.ne.iret2)) then
        call utmess('F', 'CHAINAGE_2')
    endif
!
end subroutine
