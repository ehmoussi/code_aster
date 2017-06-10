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
subroutine thmGetParaBiot(j_mater)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/get_elas_id.h"
#include "asterfort/rcvala.h"
#include "asterfort/utmess.h"
!
    integer, intent(in) :: j_mater
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get Biot parameters (for porosity evolution) (THM_DIFFU)
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elas_keyword
    integer :: elas_id
    integer, parameter :: nb_para =  4
    integer :: icodre(nb_para)
    real(kind=8) :: para_vale(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/'BIOT_COEF', 'BIOT_L   ',&
                                                           'BIOT_N   ', 'BIOT_T   '/)
!
! --------------------------------------------------------------------------------------------------
!
    para_vale(:) = r8nnem()
!
! - Read parameters
!
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                0      , ' '      , [0.d0]     ,&
                nb_para, para_name, para_vale  ,&
                icodre , 0        , nan='OUI')
!
! - Set parameters
!
    ds_thm%ds_material%biot_coef = para_vale(1)
    ds_thm%ds_material%biot_l    = para_vale(2)
    ds_thm%ds_material%biot_n    = para_vale(3)
    ds_thm%ds_material%biot_t    = para_vale(4)
!
! - Type
!
    if (icodre(1) .eq. 0) then
        ds_thm%ds_material%biot_type = BIOT_TYPE_ISOT
    else
        if (icodre(4) .eq. 0) then
            ds_thm%ds_material%biot_type = BIOT_TYPE_ORTH
        else
            ds_thm%ds_material%biot_type = BIOT_TYPE_ISTR
        endif
    endif
!
! - Get type of elasticity
!
    if (ds_thm%ds_elem%l_dof_meca) then
        call get_elas_id(j_mater, elas_id, elas_keyword)
    endif
!
! - Some checks: compatibility of elasticity with diffusion
!
    if (ds_thm%ds_elem%l_dof_meca) then
        if (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISOT) then
            if (elas_id .ne. 1) then
                call utmess('F', 'THM1_2', sk = elas_keyword)
            endif
        elseif (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISTR) then
            if (elas_id .ne. 3) then
                call utmess('F', 'THM1_2', sk = elas_keyword)
            endif
        elseif (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ORTH) then
            if (elas_id .ne. 2) then
                call utmess('F', 'THM1_2', sk = elas_keyword)
            endif
        else
            ASSERT(.false.)
        endif
    endif
!
! - Debug
!
    !WRITE(6,*) 'BIOT: ',ds_thm%ds_material%biot_type,&
    !ds_thm%ds_material%biot_coef,&
    !ds_thm%ds_material%biot_l   ,&
    !ds_thm%ds_material%biot_n   ,&
    !ds_thm%ds_material%biot_t   
!
end subroutine
