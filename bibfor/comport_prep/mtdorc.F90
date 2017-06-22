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

subroutine mtdorc(model, compor)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/comp_init.h"
#include "asterfort/comp_meta_read.h"
#include "asterfort/comp_meta_save.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=8), intent(in) :: model
    character(len=19), intent(in) :: compor
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (matallurgy)
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
    character(len=19) :: list_vale
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
    list_vale = '&&LIST_VALE'
!
! - Create COMPOR <CARTE>
!
    call comp_init(mesh, compor, 'V', nb_cmp)
!
! - Read informations from command file
!
    call comp_meta_read(list_vale)
!
! - Save informations in COMPOR <CARTE>
!
    call comp_meta_save(mesh, compor, nb_cmp, list_vale)
!
! - Clean it
!
    call jedetr(list_vale)
!
    call jedema()
!
end subroutine
