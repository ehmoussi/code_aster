! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine nonlinSystemInit(list_func_acti, nume_dof, ds_algopara, ds_contact, ds_system)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/vtcreb.h"
#include "asterfort/cfdisl.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: nume_dof
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_System), intent(inout) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Non-linear system
!
! Initializations for non-linear system
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  ds_algopara      : datastructure for algorithm parameters
! In  ds_contact       : datastructure for contact management
! In  nume_dof         : name of numbering object (NUME_DDL)
! IO  ds_system        : datastructure for non-linear system management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont_elem, l_cont_all_verif
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_10')
    endif
!
! - Active functionnalities
!
    l_cont_elem      = isfonc(list_func_acti, 'ELT_CONTACT')
    l_cont_all_verif = isfonc(list_func_acti, 'CONT_ALL_VERIF')
!
! - Create fields
!
    call vtcreb(ds_system%cninte, 'V', 'R', nume_ddlz = nume_dof)
    call vtcreb(ds_system%cnfint, 'V', 'R', nume_ddlz = nume_dof)
    call vtcreb(ds_system%cnfnod, 'V', 'R', nume_ddlz = nume_dof)
!
! - Set flag for symmetric rigidity matrix
!
    ds_system%l_rigi_syme = ds_algopara%l_matr_rigi_syme
!
! - Set flag for contact matrix to add in rigidity matrix
!
    if (l_cont_elem .and. .not.l_cont_all_verif) then
        ds_system%l_rigi_cont = ASTER_TRUE
    endif
!
! - Set flag for modifiy matrix because of contact (LAC/DISCRETE/LIAISON_UNIL)
!
    if (ds_contact%l_contact) then
        if (ds_contact%l_form_disc) then
            ds_system%l_matr_cont = cfdisl(ds_contact%sdcont_defi, 'MODI_MATR_GLOB')
        endif
        if (ds_contact%l_meca_unil) then
            if (cfdisl(ds_contact%sdcont_defi, 'UNIL_PENA')) then
                ds_system%l_matr_cont = ASTER_TRUE
            endif
        endif
    endif
!
! - Set name of numbering object
!
    ds_system%nume_dof = nume_dof
!
end subroutine
