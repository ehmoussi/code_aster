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

subroutine cagene(load, command, ligrmo, mesh, nb_dim)
!
    implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
!  Person in charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: load
    character(len=16), intent(in) :: command
    integer, intent(out) :: nb_dim
    character(len=8), intent(out) :: mesh
    character(len=19), intent(out) :: ligrmo
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Get infos
!
! --------------------------------------------------------------------------------------------------
!
! In  load      : name of load
! In  command   : command
! Out mesh      : name of mesh
! Out ligrmo    : <LIGREL> of model
! Out nb_dim    : space dimension
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: model
    character(len=24) :: nomo, phenomenon, valk(2)
    character(len=8), pointer :: p_lgrf(:) => null()
    character(len=8), pointer :: p_nomo(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Get model
!
    call getvid(' ', 'MODELE', scal=model)
!
! - <LIGREL> of model
!
    ligrmo = model//'.MODELE'
!
! - Mesh
!
    call jeveuo(ligrmo//'.LGRF', 'L', vk8 = p_lgrf)
    mesh = p_lgrf(1)
!
! - Check model/loading
!
    call dismoi('PHENOMENE', model, 'MODELE', repk=phenomenon)
    valk(1) = command
    valk(2) = phenomenon
    if (command .eq. 'AFFE_CHAR_THER' .and. phenomenon .ne. 'THERMIQUE') then
        call utmess('F', 'CHARGES2_64', nk=2, valk=valk)
    else if (command .eq. 'AFFE_CHAR_MECA' .and. phenomenon .ne. 'MECANIQUE') then
        call utmess('F', 'CHARGES2_64', nk=2, valk=valk)
    else if (command .eq. 'DEFI_CONTACT' .and. phenomenon .ne. 'MECANIQUE') then
        call utmess('F', 'CHARGES2_64', nk=2, valk=valk)
    else if (command .eq. 'AFFE_CHAR_ACOU' .and. phenomenon .ne. 'ACOUSTIQUE') then
        call utmess('F', 'CHARGES2_64', nk=2, valk=valk)
    endif
!
! - Dimension of problem
!
    call dismoi('DIM_GEOM', model, 'MODELE', repi=nb_dim)
!
! - Create .NOMO
!
    nomo = load(1:8)//'.CH'//phenomenon(1:2)//'.MODEL.NOMO'
    call wkvect(nomo, 'G V K8', 1, vk8 = p_nomo)
    p_nomo(1) = model
!
    call jedema()
end subroutine
