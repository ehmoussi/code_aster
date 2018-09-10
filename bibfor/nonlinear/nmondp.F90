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
subroutine nmondp(list_load, londe, chondp, nondp)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/ischar_iden.h"
!
integer :: nondp
character(len=24) :: chondp
character(len=19) :: list_load
aster_logical :: londe
!
! ----------------------------------------------------------------------
!
    character(len=24) :: lload_name, lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    integer :: iondp, nond, i_load, nb_load
!
    call jemarq()
!
! - Initializations
!
    londe  = .false.
    nondp  = 0
    chondp = '&&NMONDP.ONDP'
!
! - Datastructure access
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    call jeveuo(lload_name, 'L', vk24 = v_load_name)
    call jeveuo(lload_info, 'L', vi   = v_load_info)
    nb_load = v_load_info(1)
    do i_load = 1, nb_load
        if (ischar_iden(v_load_info, i_load, nb_load, 'NEUM', 'ONDE')) then
            nondp = nondp + 1
        endif
    end do
!
! --- RECUPERATION DES DONNEES DE CHARGEMENT PAR ONDE PLANE
!
    if (nondp .eq. 0) then
        call wkvect(chondp, 'V V K8', 1, iondp)
    else
        londe = .true.
        call wkvect(chondp, 'V V K8', nondp, iondp)
        nond = 0
        do i_load = 1, nb_load
            if (ischar_iden(v_load_info, i_load, nb_load, 'NEUM', 'ONDE')) then
                nond = nond + 1
                zk8(iondp+nond-1) = v_load_name(i_load)(1:8)
            endif
        end do
    endif
    call jedema()
end subroutine
