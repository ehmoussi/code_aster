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

subroutine thmGetParaElas(j_mater, kpi, temp, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/get_elas_id.h"
#include "asterfort/get_elas_para.h"
#include "asterfort/get_elasth_para.h"
#include "asterfort/utmess.h"
!
!
    integer, intent(in) :: j_mater
    integer, intent(in) :: kpi
    real(kind=8), intent(in) :: temp
    integer, intent(in) :: ndim
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get elastic parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! In  kpi          : current Gauss point
! In  temp         : current temperature
! In  ndim         : dimension of element (2 ou 3)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: g, alpha(2)
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
! - Get type of elasticity
!
    call get_elas_id(j_mater, ds_thm%ds_material%elas_id, ds_thm%ds_material%elas_keyword)
!
! - Read parameters
!
    call get_elas_para(fami, j_mater, '+', kpi, 1, &
                       ds_thm%ds_material%elas_id , ds_thm%ds_material%elas_keyword,&
                       temp = temp,&
                       e = ds_thm%ds_material%e,&
                       nu = ds_thm%ds_material%nu,&
                       e1 = ds_thm%ds_material%e_l,&
                       e2 = ds_thm%ds_material%e_t,&
                       e3 = ds_thm%ds_material%e_n,&
                       nu12 = ds_thm%ds_material%nu_lt,&
                       nu13 = ds_thm%ds_material%nu_ln,&
                       nu23 = ds_thm%ds_material%nu_tn,&
                       g1 = ds_thm%ds_material%g_lt,&
                       g2 = ds_thm%ds_material%g_ln,&
                       g3 = ds_thm%ds_material%g_tn,&
                       g  = g)
    if (ds_thm%ds_material%elas_id .eq. 3) then
        ds_thm%ds_material%g_ln = g
    endif
!
! - Read parameters (dilatation)
!
    if (ds_thm%ds_elem%l_dof_ther) then
        call get_elasth_para(fami, j_mater     , '+'   , kpi, 1, &
                             ds_thm%ds_material%elas_id , ds_thm%ds_material%elas_keyword,&
                             temp_vale_ = temp,&
                             alpha   = alpha,&
                             alpha_l = ds_thm%ds_material%alpha_l,&
                             alpha_t = ds_thm%ds_material%alpha_t,&
                             alpha_n = ds_thm%ds_material%alpha_n)
        ds_thm%ds_material%alpha = alpha(1)
    endif
!
! - Some checks: compatibility of elasticity with diffusion
!
    if (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISOT) then
        if (ds_thm%ds_material%elas_id .ne. 1 .and.&
            ds_thm%ds_material%elas_keyword .ne. 'ELAS_GONF') then
            call utmess('F', 'THM1_2', sk = ds_thm%ds_material%elas_keyword)
        endif
    elseif (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISTR) then
        if (ds_thm%ds_material%elas_id .ne. 3 .and.&
            ds_thm%ds_material%elas_keyword .ne. 'ELAS_GONF') then
            call utmess('F', 'THM1_2', sk = ds_thm%ds_material%elas_keyword)
        endif
    elseif (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ORTH) then
        if (ds_thm%ds_material%elas_id .ne. 2 .and.&
            ds_thm%ds_material%elas_keyword .ne. 'ELAS_GONF') then
            call utmess('F', 'THM1_2', sk = ds_thm%ds_material%elas_keyword)
        endif
    else
        ASSERT(.false.)
    endif
!
! - Some checks: anisotropy
!
    if (ds_thm%ds_material%elas_id .eq. 3) then
        if (ndim .ne. 3) then
            call utmess('F', 'THM1_4')
        endif
    endif
    if (ds_thm%ds_material%elas_id .eq. 2) then
        if (ndim .ne. 2) then
            call utmess('F', 'THM1_3')
        endif
    endif
!
end subroutine
