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
subroutine nmrenu(modelz    , list_func_acti, list_load,&
                  ds_measure, ds_contact    , nume_dof ,&
                  l_renumber)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/numer3.h"
#include "asterfort/utmess.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
!
character(len=*), intent(in) :: modelz
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: list_load
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=24), intent(inout) :: nume_dof
aster_logical, intent(out) :: l_renumber
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm
!
! Renumbering equations ?
!
! --------------------------------------------------------------------------------------------------
!
! IO  nume_dof         : name of numbering object (NUME_DDL)
! In  model            : name of model datastructure
! In  list_load        : list of loads
! IO  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! In  list_func_acti   : list of active functionnalities
! Out l_renumber       : .true. if renumber
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont, l_cont_cont, l_cont_xfem, l_cont_elem, l_cont_xfem_gg
    character(len=24) :: sd_iden_rela
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
!
! - No renumbering !
!
    l_renumber   = ASTER_FALSE
!
! - Active functionnalities
!
    l_cont      = isfonc(list_func_acti, 'CONTACT')
    l_cont_elem = isfonc(list_func_acti, 'ELT_CONTACT')
    l_cont_xfem = isfonc(list_func_acti, 'CONT_XFEM')
    l_cont_cont = isfonc(list_func_acti, 'CONT_CONTINU')
!
! - To change numbering
!
    if (l_cont) then
! ----- Start timer for preparation of contact
        call nmtime(ds_measure, 'Launch', 'Cont_Prep')
! ----- Get identity relation datastructure
        sd_iden_rela = ds_contact%iden_rela
! ----- Numbering to change ?
        if (l_cont_elem) then
            if (l_cont_xfem) then
                l_cont_xfem_gg = cfdisl(ds_contact%sdcont_defi,'CONT_XFEM_GG')
                if (l_cont_xfem_gg) then
                   l_renumber = ASTER_TRUE
                else
                   l_renumber = ASTER_FALSE
                endif
            else
                l_renumber = ds_contact%l_renumber
                ds_contact%l_renumber = ASTER_FALSE
            endif
        endif
! ----- Re-numbering
        if (l_renumber) then
            if (niv .ge. 2) then
                call utmess('I', 'MECANONLINE13_36')
            endif
            call numer3(modelz, list_load, nume_dof, sd_iden_rela)
        endif
! ----- Stop timer for preparation of contact
        call nmtime(ds_measure, 'Stop', 'Cont_Prep')
        call nmrinc(ds_measure, 'Cont_Prep')
    endif
!
end subroutine
