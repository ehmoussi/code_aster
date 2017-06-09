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

subroutine comp_init(mesh, compor, base, nb_cmp)
!
implicit none
!
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
!
    character(len=8) , intent(in) :: mesh
    character(len=19) , intent(in) :: compor
    character(len=1) , intent(in) :: base
    integer, intent(out) :: nb_cmp
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (all)
!
! Initialization of COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh     : name of mesh
! In  compor   : name of <CARTE> COMPOR
! In  base     : base where create <CARTE> COMPOR
! Out nb_cmp   : number of components in <CARTE> COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nume_gd
    integer :: nb_cmp_max, icmp
    character(len=8) :: name_gd
    character(len=16), pointer :: p_compor_valv(:) => null()
    character(len=8) , pointer :: p_cata_nomcmp(:) => null()
    character(len=8) , pointer :: p_compor_ncmp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_cmp  = 0
    name_gd = 'COMPOR'   
!
! - Read catalog
!
    call jenonu(jexnom('&CATA.GD.NOMGD', name_gd), nume_gd)
    call jeveuo(jexnum('&CATA.GD.NOMCMP', nume_gd), 'L', vk8 = p_cata_nomcmp)
    call jelira(jexnum('&CATA.GD.NOMCMP', nume_gd), 'LONMAX', nb_cmp_max)
!
! - Allocate <CARTE>
!
    call alcart(base, compor, mesh, name_gd)
!
! - Acces to <CARTE>
!
    call jeveuo(compor(1:19)//'.NCMP', 'E', vk8  = p_compor_ncmp)
    call jeveuo(compor(1:19)//'.VALV', 'E', vk16 = p_compor_valv)
!
! - Init <CARTE>
!
    do icmp = 1, nb_cmp_max
        p_compor_ncmp(icmp) = p_cata_nomcmp(icmp)
        p_compor_valv(icmp) = ' '
    enddo
!
    nb_cmp = nb_cmp_max

end subroutine
