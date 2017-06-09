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

subroutine nmimre(ds_conv, ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmimcr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Conv), intent(in) :: ds_conv
    type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Set value of residuals informations in convergence table
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_conv          : datastructure for convergence management
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_resi, nb_resi
    real(kind=8) :: vale_calc
    character(len=16) :: locus_calc
    character(len=24) :: col_name, col_name_locus
!
! --------------------------------------------------------------------------------------------------
!
    nb_resi = ds_conv%nb_resi
!
! - Loop on residuals
!
    do i_resi = 1, nb_resi
        vale_calc       = ds_conv%list_resi(i_resi)%vale_calc
        locus_calc      = ds_conv%list_resi(i_resi)%locus_calc
        col_name        = ds_conv%list_resi(i_resi)%col_name
        col_name_locus  = ds_conv%list_resi(i_resi)%col_name_locus
        call nmimcr(ds_print, col_name      , vale_calc , l_affe = .true._1)
        call nmimck(ds_print, col_name_locus, locus_calc, l_affe = .true._1)
    end do
!
end subroutine
