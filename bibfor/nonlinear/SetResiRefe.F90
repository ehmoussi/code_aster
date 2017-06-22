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

subroutine SetResiRefe(ds_conv   , type_ ,&
                       user_para_, cmp_name_, l_refe_test_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Conv), intent(inout) :: ds_conv
    character(len=*), optional, intent(in) :: type_
    character(len=*), optional, intent(in) :: cmp_name_
    real(kind=8), optional, intent(in) :: user_para_
    aster_logical, optional, intent(in) :: l_refe_test_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Convergence management
!
! Set values for reference residual (by name)
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_conv          : datastructure for convergence management
! In  type             : type of residual
!                        If .not. present => all residuals
! In  user_para        : user parameter for residual
! In  cmp_name         : name of component
! In  l_refe_test      : .true. to test this residual to evaluate convergence
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_refe, nb_refe, i_type
!
! --------------------------------------------------------------------------------------------------
!
    i_type      = 0
    nb_refe     = ds_conv%nb_refe
!
! - On all residuals
!
    if (.not.present(type_)) then
        do i_refe = 1, nb_refe
            if (present(user_para_)) then
                ds_conv%list_refe(i_refe)%user_para = user_para_
            endif
            if (present(cmp_name_)) then
                ds_conv%list_refe(i_refe)%cmp_name  = cmp_name_
            endif
            if (present(l_refe_test_)) then
                ds_conv%l_refe_test(i_refe)         = l_refe_test_
            endif
        end do
    endif
!
! - On one residual
!
    if (present(type_)) then
        do i_refe = 1, nb_refe
            if (ds_conv%list_refe(i_refe)%type .eq. type_) then
                ASSERT(i_type.eq.0)
                i_type = i_refe
            endif
        end do
        ASSERT(i_type.ne.0)
        if (present(user_para_)) then
            ds_conv%list_refe(i_type)%user_para = user_para_
        endif
        if (present(cmp_name_)) then
            ds_conv%list_refe(i_type)%cmp_name  = cmp_name_
        endif
        if (present(l_refe_test_)) then
            ds_conv%l_refe_test(i_type)         = l_refe_test_
        endif
    endif
!
end subroutine
