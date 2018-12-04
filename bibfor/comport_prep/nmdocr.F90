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
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdocr(model, carcri, l_implex)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/carc_info.h"
#include "asterfort/carc_init.h"
#include "asterfort/carc_read.h"
#include "asterfort/carc_save.h"
#include "asterfort/dismoi.h"
#include "asterfort/nocart.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
!
character(len=8), intent(in)   :: model
character(len=24), intent(out) :: carcri
aster_logical, intent(in) :: l_implex
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get parameters from COMPORTEMENT keyword and prepare CARCRI <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! Out carcri           : name of <CARTE> CARCRI
! In  l_implex         : .true. if IMPLEX method
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: mesh
    integer :: nb_cmp
    type(Behaviour_PrepCrit) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE12_5')
    endif
!
! - Initialisations
!
    carcri = '&&NMDOCR.CARCRI'
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
!
! - Create carcri informations objects
!
    call carc_info(ds_compor_para)
!
! - Create CARCRI <CARTE>
!
    call carc_init(mesh, carcri, nb_cmp)
!
! - Default CARCRI <CARTE> on all mesh
!
    call nocart(carcri, 1, nb_cmp)
!
! - Read informations from command file
!
    call carc_read(ds_compor_para, model, l_implex)
!
! - Save and check informations in CARCRI <CARTE>
!
    call carc_save(model, mesh, carcri, nb_cmp, ds_compor_para)
!
! - Cleaning
!
    deallocate(ds_compor_para%v_para)
!
end subroutine
