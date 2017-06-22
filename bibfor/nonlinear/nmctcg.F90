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

subroutine nmctcg(model, mesh, ds_contact, ds_measure)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/xmctcg.h"
#include "asterfort/mmctcg.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: model
    type(NL_DS_Contact), intent(inout) :: ds_contact
    type(NL_DS_Measure), intent(inout) :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Continue/XFEM method
!
! Geometric loop: geometric actualisation and pairing 
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! IO  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cont_form
    aster_logical :: l_cont_allv
!
! --------------------------------------------------------------------------------------------------
!
    cont_form   = cfdisi(ds_contact%sdcont_defi,'FORMULATION')
    l_cont_allv = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF')
!
! - Geometric loop: geometric actualisation and pairing
!
    if (.not.l_cont_allv) then
        if (cont_form .eq. 2) then
            call mmctcg(mesh , ds_contact, ds_measure)
        elseif (cont_form .eq. 3) then
            call xmctcg(model, mesh, ds_contact, ds_measure)
        endif
    endif
!
end subroutine
