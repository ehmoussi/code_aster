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
!
subroutine mmchml(mesh, ds_contact, sddisc, sddyna, nume_inst)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/alchml.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/cfdisl.h"
#include "asterfort/detrsd.h"
#include "asterfort/diinst.h"
#include "asterfort/mmchml_c.h"
#include "asterfort/mmchml_l.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: sddisc
character(len=19), intent(in) :: sddyna
integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue methods - Create and fill input field
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  sddisc           : datastructure for time discretization
! In  sddyna           : datastructure for dynamic
! In  nume_inst        : index of current time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: ligrcf, chmlcf
    real(kind=8) :: time_prev, time_curr, time_incr
    aster_logical :: l_new_pair, l_cont_cont, l_cont_lac
    integer :: iret
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'CONTACT5_26')
    endif
!
! - <LIGREL> for contact elements
!
    ligrcf = ds_contact%ligrel_elem_cont
!
! - <CHELEM> for input field
!
    chmlcf = ds_contact%field_input
!
! - Get parameters
!
    l_cont_cont  = cfdisl(ds_contact%sdcont_defi, 'FORMUL_CONTINUE')
    l_cont_lac   = cfdisl(ds_contact%sdcont_defi, 'FORMUL_LAC')
!
! - Get time parameters
!
    time_prev = diinst(sddisc,nume_inst-1)
    time_curr = diinst(sddisc,nume_inst)
    time_incr = time_curr-time_prev
!
! - Create input field
!
    l_new_pair = ds_contact%l_renumber
    if (l_new_pair .and. ds_contact%nb_cont_pair.ne.0) then
        call detrsd('CHAM_ELEM', chmlcf)
        call alchml(ligrcf, 'RIGI_CONT', 'PCONFR', 'V', chmlcf, iret, ' ')
        ASSERT(iret.eq.0)
    endif
!
! - Fill input field
!
    if (l_cont_cont) then
        call mmchml_c(ds_contact, ligrcf, chmlcf, sddyna, time_incr)
    else if (l_cont_lac) then
        call mmchml_l(mesh, ds_contact, ligrcf, chmlcf)
    endif
!
end subroutine
