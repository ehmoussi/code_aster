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

subroutine thmGetElemInfo()
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lteatt.h"
!
!

!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get type of finite element
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
end subroutine
