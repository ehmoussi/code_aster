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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmctce(model    , mesh, ds_contact, sddyna, sddisc,&
                  nume_inst)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/mmchml.h"
#include "asterfort/xmcart.h"
!
character(len=8), intent(in) :: model
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in)  :: sddyna
character(len=19), intent(in)  :: sddisc
integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Continue/XFEM method
!
! Create elements for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  sddyna           : dynamic parameters datastructure
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cont_form
    aster_logical :: l_cont_xfem_gg
!
! --------------------------------------------------------------------------------------------------
!
    cont_form      = cfdisi(ds_contact%sdcont_defi,'FORMULATION')
    l_cont_xfem_gg = cfdisl(ds_contact%sdcont_defi,'CONT_XFEM_GG')
!
! - Create input fields for contact
!
    if (cont_form .eq. 2 .or. cont_form .eq. 5) then
        call mmchml(mesh, ds_contact, sddisc, sddyna, nume_inst)
    elseif  (cont_form .eq. 3) then
        if (l_cont_xfem_gg) then
            call xmcart(mesh, model, ds_contact)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
