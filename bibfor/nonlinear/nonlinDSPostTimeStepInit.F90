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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSPostTimeStepInit(ds_algopara, ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
!
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Post-treatment management
!
! Initializations for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_algopara      : datastructure for algorithm parameters
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... Initializations for post-treatment at each time step'
    endif
!
! - Parameters for CRIT_STAB
!
    if (ds_posttimestep%l_crit_stab) then
        ds_posttimestep%crit_stab%type_matr_rigi = ds_algopara%matrix_pred
    endif
!
! - Initializations
!
    ds_posttimestep%mode_vibr_resu%eigen_value  = r8vide()
    ds_posttimestep%mode_vibr_resu%eigen_index  = -1
    ds_posttimestep%mode_vibr_resu%eigen_vector = '&&NMDOPO.VIBMOD'
    ds_posttimestep%mode_flam_resu%eigen_value  = r8vide()
    ds_posttimestep%mode_flam_resu%eigen_index  = -1
    ds_posttimestep%mode_flam_resu%eigen_vector = '&&NMDOPO.FLAMOD'
    ds_posttimestep%crit_stab_resu%eigen_value  = r8vide()
    ds_posttimestep%crit_stab_resu%eigen_index  = -1
    ds_posttimestep%crit_stab_resu%eigen_vector = '&&NMDOPO.STAMOD'
!
end subroutine
