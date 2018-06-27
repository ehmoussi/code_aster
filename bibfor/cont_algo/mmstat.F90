! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine mmstat(mesh  , iter_newt, nume_inst     , &
                  sddisc, disp_curr, disp_cumu_inst, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/mmmbca.h"
#include "asterfort/mmmbca_lac.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: iter_newt
    integer, intent(in) :: nume_inst
    character(len=19), intent(in) :: sddisc
    character(len=19), intent(in) :: disp_curr
    character(len=19), intent(in) :: disp_cumu_inst
    type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue methods - Management of contact loop
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  iter_newt        : index of current Newton iteration
! In  nume_inst        : index of current time step
! IO  ds_measure       : datastructure for measure and statistics management
! In  sddisc           : datastructure for time discretization
! In  disp_curr        : current displacements
! In  disp_cumu_inst   : displacement increment from beginning of current time
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_cont_cont, l_cont_lac
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get parameters
!
    l_cont_cont  = cfdisl(ds_contact%sdcont_defi, 'FORMUL_CONTINUE')
    l_cont_lac   = cfdisl(ds_contact%sdcont_defi, 'FORMUL_LAC')
!
    if (l_cont_cont) then
        call mmmbca(mesh  , iter_newt, nume_inst     , &
                    sddisc, disp_curr, disp_cumu_inst, ds_contact)
    elseif (l_cont_lac) then
        call mmmbca_lac(mesh, disp_curr, ds_contact)
    else
        ASSERT(.false.)
    endif
!
end subroutine
