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
subroutine thmGetParaTher(j_mater, kpi, temp)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/get_elasth_para.h"
#include "asterfort/THM_type.h"
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
    integer :: biot_type
    integer, parameter :: nb_resu1 = 4
    character(len=16), parameter :: resu_name1(nb_resu1) = (/'LAMB_T ', 'LAMB_TL',&
                                                             'LAMB_TN', 'LAMB_TT'/)
    real(kind=8) :: resu_vale1(nb_resu1)
    integer :: icodre1(nb_resu1)
    integer, parameter :: nb_resu2 = 4
    character(len=16), parameter :: resu_name2(nb_resu2) = (/'D_LB_T ', 'D_LB_TL',&
                                                             'D_LB_TN', 'D_LB_TT'/)
    real(kind=8) :: resu_vale2(nb_resu2)
    integer :: icodre2(nb_resu2)
    integer, parameter :: nb_resu3 = 4
    character(len=16), parameter :: resu_name3(nb_resu3) = (/'LAMB_CT ', 'LAMB_C_L',&
                                                             'LAMB_C_N', 'LAMB_C_T'/)
    real(kind=8) :: resu_vale3(nb_resu3)
    integer :: icodre3(nb_resu3)
!
! --------------------------------------------------------------------------------------------------
!
    fami = 'RIGI'
!
! - Read parameters (mechanic dilatation)
!
    if (ds_thm%ds_elem%l_dof_ther .and. ds_thm%ds_elem%l_dof_meca) then
        call get_elasth_para(fami, j_mater     , '+'   , kpi, 1, &
                             ds_thm%ds_material%elas%id , ds_thm%ds_material%elas%keyword,&
                             temp_vale_ = temp,&
                             alpha   = alpha,&
                             alpha_l = ds_thm%ds_material%ther%alpha_l,&
                             alpha_t = ds_thm%ds_material%ther%alpha_t,&
                             alpha_n = ds_thm%ds_material%ther%alpha_n)
        ds_thm%ds_material%ther%alpha = alpha(1)
    else
        ds_thm%ds_material%ther%alpha   = 0.d0
        ds_thm%ds_material%ther%alpha_l = 0.d0
        ds_thm%ds_material%ther%alpha_t = 0.d0
        ds_thm%ds_material%ther%alpha_n = 0.d0
    endif
!
! - Read parameters for conductivity
!
    biot_type = ds_thm%ds_material%biot%type
    if (ds_thm%ds_elem%l_dof_ther) then
        resu_vale1(:) = 0.d0
        resu_vale2(:) = 0.d0
        resu_vale3(:) = 0.d0
        call rcvala(j_mater, ' '        , 'THM_DIFFU',&
                    1      , 'TEMP'     , [temp]     ,&
                    nb_resu1, resu_name1, resu_vale1 ,&
                    icodre1 , 0         , nan='NON')
        ds_thm%ds_material%ther%lambda     = resu_vale1(1)
        ds_thm%ds_material%ther%lambda_tl  = resu_vale1(2)
        ds_thm%ds_material%ther%lambda_tn  = resu_vale1(3)
        ds_thm%ds_material%ther%lambda_tt  = resu_vale1(4)
        call rcvala(j_mater, ' '        , 'THM_DIFFU',&
                    1      , 'TEMP'     , [temp]     ,&
                    nb_resu2, resu_name2, resu_vale2 ,&
                    icodre2 , 0         , nan='NON')
        ds_thm%ds_material%ther%dlambda    = resu_vale2(1)
        ds_thm%ds_material%ther%dlambda_tl = resu_vale2(2)
        ds_thm%ds_material%ther%dlambda_tn = resu_vale2(3)
        ds_thm%ds_material%ther%dlambda_tt = resu_vale2(4)
        call rcvala(j_mater, ' '        , 'THM_DIFFU',&
                    1      , 'TEMP'     , [temp]     ,&
                    nb_resu3, resu_name3, resu_vale3 ,&
                    icodre3 , 0         , nan='NON')
        ds_thm%ds_material%ther%lambda_ct   = resu_vale3(1)
        ds_thm%ds_material%ther%lambda_ct_l = resu_vale3(2)
        ds_thm%ds_material%ther%lambda_ct_n = resu_vale3(3)
        ds_thm%ds_material%ther%lambda_ct_t = resu_vale3(4)
        if (icodre1(1) .eq. 0) then
            ds_thm%ds_material%ther%cond_type = THER_COND_ISOT
            ASSERT(icodre1(2) .eq. 1)
            ASSERT(icodre1(3) .eq. 1)
            ASSERT(icodre1(4) .eq. 1)
        else
            if (icodre1(4) .eq. 0) then
                ds_thm%ds_material%ther%cond_type = THER_COND_ORTH
            else
                ds_thm%ds_material%ther%cond_type = THER_COND_ISTR
            endif
        endif
    else
        ds_thm%ds_material%ther%cond_type   = THER_COND_ISOT
        ds_thm%ds_material%ther%lambda      = 0
        ds_thm%ds_material%ther%lambda_tl   = 0
        ds_thm%ds_material%ther%lambda_tn   = 0
        ds_thm%ds_material%ther%lambda_tt   = 0
        ds_thm%ds_material%ther%dlambda     = 0
        ds_thm%ds_material%ther%dlambda_tl  = 0
        ds_thm%ds_material%ther%dlambda_tn  = 0
        ds_thm%ds_material%ther%dlambda_tt  = 0
        ds_thm%ds_material%ther%lambda_ct   = 0
        ds_thm%ds_material%ther%lambda_ct_l = 0
        ds_thm%ds_material%ther%lambda_ct_n = 0
        ds_thm%ds_material%ther%lambda_ct_t = 0
    endif





!
end subroutine
