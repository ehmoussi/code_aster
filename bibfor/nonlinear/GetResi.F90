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

subroutine GetResi(ds_conv   , type  ,&
                   col_name_ , col_name_locus_, vale_calc_  , locus_calc_, user_para_,&
                   l_conv_   , event_type_    , l_resi_test_)
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
    type(NL_DS_Conv), intent(in) :: ds_conv
    character(len=*), intent(in) :: type
    character(len=16), optional, intent(out) :: col_name_
    character(len=16), optional, intent(out) :: col_name_locus_
    real(kind=8), optional, intent(out) :: vale_calc_
    character(len=16), optional, intent(out) :: locus_calc_
    real(kind=8), optional, intent(out) :: user_para_
    aster_logical, optional, intent(out) :: l_conv_
    character(len=16), optional, intent(out)  :: event_type_
    aster_logical, optional, intent(out) :: l_resi_test_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Convergence management
!
! Get values for residual (by type)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_conv          : datastructure for convergence management
! In  type             : type of residual
! Out col_name         : name of columns in convergence table for value
! Out col_name_locus   : name of columns in convergence table for locus
! Out vale_calc        : result of maximum norm of residual
! Out locus_calc       : locus where is maximum norm of residual
! Out user_para        : user parameter for residual
! Out l_conv           : .true. if residual has converged
! Out event_type       : type of event
! Out l_resi_test      : .true. to test this resiudal to evaluate convergence
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_resi, nb_resi, i_type
!
! --------------------------------------------------------------------------------------------------
!
    i_type  = 0
    nb_resi = ds_conv%nb_resi
!
! - Find residual
!
    do i_resi = 1, nb_resi
        if (ds_conv%list_resi(i_resi)%type .eq. type) then
            ASSERT(i_type.eq.0)
            i_type = i_resi
        endif
    end do
    ASSERT(i_type.ne.0)
!
! - Get parameters
!
    if (present(vale_calc_)) then
        vale_calc_      = ds_conv%list_resi(i_type)%vale_calc
    endif
    if (present(locus_calc_)) then
        locus_calc_     = ds_conv%list_resi(i_type)%locus_calc
    endif
    if (present(user_para_)) then
        user_para_      = ds_conv%list_resi(i_type)%user_para
    endif
    if (present(l_conv_)) then
        l_conv_         = ds_conv%list_resi(i_type)%l_conv
    endif
    if (present(col_name_)) then
        col_name_       = ds_conv%list_resi(i_type)%col_name
    endif
    if (present(col_name_locus_)) then
        col_name_locus_ = ds_conv%list_resi(i_type)%col_name_locus
    endif
    if (present(event_type_)) then
        event_type_     = ds_conv%list_resi(i_type)%event_type
    endif
    if (present(l_resi_test_)) then
        l_resi_test_    = ds_conv%l_resi_test(i_type)
    endif
 
!
end subroutine
