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

subroutine thmGetParaTher(j_mater, kpi, temp)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/get_elasth_para.h"
!
!
    integer, intent(in) :: j_mater
    integer, intent(in) :: kpi
    real(kind=8), intent(in) :: temp
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get thermic parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! In  kpi          : current Gauss point
! In  temp         : current temperature
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: alpha(2)
    character(len=8) :: fami
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_thm%ds_elem%l_weak_coupling) then
        fami = 'RIGI'
    else
        fami = ' '
    endif
!
! - Read parameters (dilatation)
!
    if (ds_thm%ds_elem%l_dof_ther .and. ds_thm%ds_elem%l_dof_meca) then
        call get_elasth_para(fami, j_mater     , '+'   , kpi, 1, &
                             ds_thm%ds_material%elas_id , ds_thm%ds_material%elas_keyword,&
                             temp_vale_ = temp,&
                             alpha   = alpha,&
                             alpha_l = ds_thm%ds_material%alpha_l,&
                             alpha_t = ds_thm%ds_material%alpha_t,&
                             alpha_n = ds_thm%ds_material%alpha_n)
        ds_thm%ds_material%alpha = alpha(1)
    else
        ds_thm%ds_material%alpha   = 0.d0
        ds_thm%ds_material%alpha_l = 0.d0
        ds_thm%ds_material%alpha_t = 0.d0
        ds_thm%ds_material%alpha_n = 0.d0
    endif
!
end subroutine
