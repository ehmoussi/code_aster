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
subroutine mtdorc(model, compor)
!
use Metallurgy_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/comp_init.h"
#include "asterfort/comp_meta_info.h"
#include "asterfort/comp_meta_read.h"
#include "asterfort/comp_meta_save.h"
#include "asterfort/comp_meta_pvar.h"
#include "asterfort/comp_meta_prnt.h"
#include "asterfort/dismoi.h"
!
character(len=8), intent(in) :: model
character(len=19), intent(in) :: compor
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Prepare objects COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  model       : name of model
! In  compor      : name of <CARTE> COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cmp
    character(len=8) :: mesh
    character(len=19) :: compor_info
    type(META_PrepPara) :: ds_comporMeta
!
! --------------------------------------------------------------------------------------------------
!
    compor_info = '&&MTDORC.INFO'
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
!
! - Create datastructure to prepare comportement
!
    call comp_meta_info(ds_comporMeta)
!
! - Create COMPOR <CARTE>
!
    call comp_init(mesh, compor, 'V', nb_cmp)
!
! - Read informations from command file
!
    call comp_meta_read(ds_comporMeta)
!
! - Save informations in COMPOR <CARTE>
!
    call comp_meta_save(mesh         , compor, nb_cmp, &
                        ds_comporMeta)
!
! - Prepare informations about internal variables
!
    call comp_meta_pvar(model, compor, compor_info)
!
! - Print informations about internal variables
!
    call comp_meta_prnt(compor_info)
!
! - Cleaning
!
    deallocate(ds_comporMeta%v_comp)
!
end subroutine
