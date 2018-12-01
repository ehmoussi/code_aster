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
subroutine nmetac(list_func_acti, sddyna, ds_contact, ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/SetIOField.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_InOut), intent(inout) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Input/output datastructure
!
! Select fields depending on active functionnalities
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : name of dynamic parameters datastructure
! In  ds_contact       : datastructure for contact management
! IO  ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_defi
    aster_logical :: l_cont_xfem, l_frot_xfem, l_xfem_czm, l_cont
    aster_logical :: l_dyna, l_muap, l_strx
    aster_logical :: l_ener
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = ds_contact%sdcont_defi
!
! - Active functionnalities
!
    l_dyna      = ndynlo(sddyna,'DYNAMIQUE' )
    l_muap      = ndynlo(sddyna,'MULTI_APPUI')
    l_strx      = isfonc(list_func_acti,'EXI_STRX')
    l_ener      = isfonc(list_func_acti,'ENERGIE' )
    l_cont_xfem = isfonc(list_func_acti,'CONT_XFEM' )
    l_cont      = isfonc(list_func_acti,'CONTACT' )
    if (l_cont_xfem) then
        l_frot_xfem = isfonc(list_func_acti,'FROT_XFEM')
        l_xfem_czm  = cfdisl(sdcont_defi,'EXIS_XFEM_CZM')
    endif
!
! - Standard: DEPL/SIEF_ELGA/VARI_ELGA/FORC_NODA/COMPOR/EPSI_ELGA
!
    call SetIOField(ds_inout, 'DEPL'        , l_acti_ = ASTER_TRUE)
    call SetIOField(ds_inout, 'SIEF_ELGA'   , l_acti_ = ASTER_TRUE)
    call SetIOField(ds_inout, 'EPSI_ELGA'   , l_acti_ = ASTER_TRUE)
    call SetIOField(ds_inout, 'VARI_ELGA'   , l_acti_ = ASTER_TRUE)
    call SetIOField(ds_inout, 'FORC_NODA'   , l_acti_ = ASTER_TRUE)    
    call SetIOField(ds_inout, 'COMPORTEMENT', l_acti_ = ASTER_TRUE) 
!
! - Dynamic: VITE/ACCE
!
    if (l_dyna) then
        call SetIOField(ds_inout, 'VITE', l_acti_ = ASTER_TRUE)
        call SetIOField(ds_inout, 'ACCE', l_acti_ = ASTER_TRUE)
    endif
!
! - XFEM
!
    if (l_cont_xfem) then
        call SetIOField(ds_inout, 'INDC_ELEM', l_acti_ = ASTER_TRUE)
        if (l_frot_xfem) then
            call SetIOField(ds_inout, 'SECO_ELEM', l_acti_ = ASTER_TRUE)
        endif
        if (l_xfem_czm) then
            call SetIOField(ds_inout, 'COHE_ELEM', l_acti_ = ASTER_TRUE)
        endif
    endif
!
! - Contact
!
    if (l_cont) then
        if (ds_contact%l_cont_node) then
            call SetIOField(ds_inout, 'CONT_NOEU', l_acti_ = ASTER_TRUE)
        endif
        if (ds_contact%l_cont_elem) then
            call SetIOField(ds_inout, 'CONT_ELEM', l_acti_ = ASTER_TRUE)
        endif
    endif
!
! - "MULTI-APPUIS": DEPL/VITE/ACCE d'entrainement
!
    if (l_muap) then
        call SetIOField(ds_inout, 'DEPL_ABSOLU', l_acti_ = ASTER_TRUE)
        call SetIOField(ds_inout, 'VITE_ABSOLU', l_acti_ = ASTER_TRUE)
        call SetIOField(ds_inout, 'ACCE_ABSOLU', l_acti_ = ASTER_TRUE)
    endif
!
! - Special elements: multifibers beams
!
    if (l_strx) then
        call SetIOField(ds_inout, 'STRX_ELGA', l_acti_ = ASTER_TRUE)
    endif
!
! - Energy
!
    if (l_ener) then
        call SetIOField(ds_inout, 'FORC_AMOR', l_acti_ = ASTER_TRUE)
        call SetIOField(ds_inout, 'FORC_LIAI', l_acti_ = ASTER_TRUE)
    endif
!
end subroutine
