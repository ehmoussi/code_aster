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
subroutine thmGetElemModel(l_axi_, l_vf_, type_vf_, l_steady_, ndim_, type_elem_)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
!
aster_logical, optional, intent(out) :: l_axi_, l_steady_, l_vf_
integer, optional, intent(out) :: ndim_, type_vf_
character(len=8), optional, intent(out) :: type_elem_(2)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get model of finite element
!
! --------------------------------------------------------------------------------------------------
!
! Out l_axi            : flag is axisymmetric model
! Out l_vf             : flag for finite volume
! Out type_vf          : type for finite volume
! Out l_steady         : .true. for steady state
! Out ndim             : dimension of element (2 ou 3)
! Out type_elem        : type of element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret1, iret2
    real(kind=8) :: r8bid
    aster_logical :: l_axi, l_steady, l_vf
    integer :: ndim, type_vf
    character(len=8) :: type_elem(2)
!
! --------------------------------------------------------------------------------------------------
!
    l_axi        = .false.
    ndim         = 0
    type_vf      = 0
    type_elem(:) = ' '
    l_steady     = .false.
    l_vf         = .false.
!
! - Get dof in finite element
!
    ds_thm%ds_elem%l_dof_ther  = lteatt('THER','OUI')
    ds_thm%ds_elem%l_dof_meca  = lteatt('MECA','OUI')
    ds_thm%ds_elem%l_dof_pre1  = .not. lteatt('HYDR1','0')
    ds_thm%ds_elem%l_dof_pre2  = .not. lteatt('HYDR2','0')
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
! - Get general model
!
    l_axi = .false.
    if (lteatt('AXIS','OUI')) then
        l_axi        = .true.
        type_elem(1) = 'AXIS'
        ndim         = 2
    else if (lteatt('D_PLAN','OUI')) then
        type_elem(1) = 'D_PLAN'
        ndim         = 2
    else
        type_elem(1) = '3D'
        ndim         = 3
    endif
!
! - Steady problem ?
!
    l_steady = lteatt('TYPMOD3','STEADY')
!
! - Finite volume
!
    l_vf = lteatt('TYPMOD3','SUSHI')
    if (l_vf) then
        type_vf = 3
    endif
!
! - Copy
!
    if (present(l_axi_)) then
        l_axi_ = l_axi
    endif
    if (present(l_vf_)) then
        l_vf_  = l_vf
    endif
    if (present(type_vf_)) then
        type_vf_ = type_vf
    endif
    if (present(l_steady_)) then
        l_steady_ = l_steady
    endif
    if (present(ndim_)) then
        ndim_ = ndim
    endif
    if (present(type_elem_)) then
        type_elem_ = type_elem
    endif
!
end subroutine
