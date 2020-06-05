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
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdocc(model, chmate, l_etat_init, l_implex, compor)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/comp_init.h"
#include "asterfort/comp_meca_info.h"
#include "asterfort/comp_meca_chck.h"
#include "asterfort/comp_meca_cvar.h"
#include "asterfort/comp_meca_elas.h"
#include "asterfort/comp_meca_full.h"
#include "asterfort/comp_meca_read.h"
#include "asterfort/comp_meca_save.h"
#include "asterfort/dismoi.h"
#include "asterfort/nocart.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
!
character(len=8), intent(in) :: model, chmate
aster_logical, intent(in) :: l_etat_init, l_implex
character(len=19), intent(in) :: compor
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of behaviour (mechanics)
!
! Get parameters from COMPORTEMENT keyword and prepare COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  chmate           : name of material field
! In  l_etat_init      : .true. if initial state is defined
! In  l_implex         : .true. if IMPLEX method
! In  compor           : name of <CARTE> COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_cmp
    character(len=8) :: mesh, answer
    character(len=19) :: comp_elas, full_elem_s
    type(Behaviour_PrepPara) :: ds_compor_prep
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE12_4')
    endif
!
! - Initialisations
!
    comp_elas   = '&&NMDOCC.COMP_ELAS'
    full_elem_s = '&&NMDOCC.FULL_ELEM'
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
!
! - Create datastructure to prepare comportement
!
    call comp_meca_info(l_implex, ds_compor_prep)
    if (ds_compor_prep%nb_comp .eq. 0) then
        call utmess('I', 'COMPOR4_64')
    endif
    if (ds_compor_prep%nb_comp .ge. 99999) then
        call utmess('A', 'COMPOR4_65')
    endif
!
! - Create COMPOR <CARTE>
!
    call comp_init(mesh, compor, 'V', nb_cmp)
!
! - Set ELASTIQUE COMPOR
!
    call comp_meca_elas(compor, nb_cmp, l_etat_init)
!
! - Default ELASTIQUE COMPOR <CARTE> on all mesh
!
    call nocart(compor, 1, nb_cmp)
!
! - Read informations from command file
!
    call comp_meca_read(l_etat_init, ds_compor_prep, model)
!
! - Create <CARTE> of FULL_MECA option for checking
!
    call comp_meca_full(model, compor, full_elem_s)
!
! - Check informations in COMPOR <CARTE>
!
    call comp_meca_chck(model, mesh, full_elem_s, l_etat_init, ds_compor_prep)
    call dismoi('EXI_VARC', chmate, 'CHAM_MATER', repk=answer)
    if (answer .eq. 'OUI' .and. ds_compor_prep%lNonIncr) then
        call utmess('A', 'COMPOR4_17')
    endif
!
! - Count internal variables
!
    call comp_meca_cvar(ds_compor_prep)
!
! - Save informations in COMPOR <CARTE>
!
    call comp_meca_save(model, mesh, chmate, compor, nb_cmp, ds_compor_prep)
!
! - Cleaning
!
    deallocate(ds_compor_prep%v_para)
    deallocate(ds_compor_prep%v_paraExte)
!
end subroutine
