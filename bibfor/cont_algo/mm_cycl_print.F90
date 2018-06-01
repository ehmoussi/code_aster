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

subroutine mm_cycl_print(ds_print, ds_measure)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/nmrvai.h"
#include "asterfort/nmimcr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Informations printing in convergence table
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cycl_nb(4),cycl_nb_tot
    real(kind=8) :: resi_pressure
!
! --------------------------------------------------------------------------------------------------
!
    resi_pressure = ds_print%resi_pressure
    call nmrvai(ds_measure, 'Cont_Cycl1', phasis = 'N', output_count = cycl_nb(1))
    call nmrvai(ds_measure, 'Cont_Cycl2', phasis = 'N', output_count = cycl_nb(2))
    call nmrvai(ds_measure, 'Cont_Cycl3', phasis = 'N', output_count = cycl_nb(3))
    call nmrvai(ds_measure, 'Cont_Cycl4', phasis = 'N', output_count = cycl_nb(4))
    cycl_nb_tot = cycl_nb(1) + cycl_nb(2) + cycl_nb(3) + cycl_nb(4)
    call nmimcr(ds_print, 'CTCC_CYCL', resi_pressure, .true._1)

end subroutine
