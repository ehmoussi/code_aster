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

subroutine load_unde_diri(list_load)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/copich.h"
#include "asterfort/copisd.h"
#include "asterfort/jedetr.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedup1.h"
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
!
!
    character(len=19), intent(in) :: list_load
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Special copy for undead Dirichlet loads
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load         : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_load, load_nume_diri, i_load, i_load_diri,i
    character(len=8) :: load_name, load_name_loca
    character(len=24) :: lload_info, lload_name
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24), pointer :: noli(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Datastructure access
!
    lload_info = list_load(1:19)//'.INFC'
    lload_name = list_load(1:19)//'.LCHA'
    call jeveuo(lload_name, 'E', vk24 = v_load_name)
    call jeveuo(lload_info, 'E', vi   = v_load_info)
!
    nb_load     = v_load_info(1)
    ASSERT(nb_load.gt.0)
    i_load_diri = 0
!
! - Copy loads
!
    do i_load = 1, nb_load
        load_nume_diri = v_load_info(i_load+1)
        if (load_nume_diri.eq.4) then
            i_load_diri = i_load_diri + 1
            load_name_loca = '&&DIRISU'
            if (i_load_diri.gt.99) then
                call utmess('F','CHARGES_29')
            endif
            call codent(i_load_diri, 'D0', load_name_loca(7:8))
            load_name      = v_load_name(i_load)(1:8)


!           -- delete :
            call jedetr(load_name_loca//'.TYPE')
            call jedetr(load_name_loca//'.CHME.MODEL.NOMO')
            call detrsd('LIGREL',load_name_loca//'.CHME.LIGRE')
            call detrsd('CARTE', load_name_loca//'.CHME.CMULT')
            call detrsd('CARTE', load_name_loca//'.CHME.CIMPO')
            call jedetr(load_name_loca//'.DUAL.PRDK')
            call jedetr(load_name_loca//'.DUAL.PRDI')
            call jedetr(load_name_loca//'.DUAL.PRDSO')


!           -- copy :
            call jedup1(load_name//'.TYPE', 'V', load_name_loca//'.TYPE')
            call jedup1(load_name//'.CHME.MODEL.NOMO', 'V', load_name_loca//'.CHME.MODEL.NOMO')
            call copisd('LIGREL', 'V', load_name//'.CHME.LIGRE', load_name_loca//'.CHME.LIGRE')
            call copich('V', load_name//'.CHME.CMULT', load_name_loca//'.CHME.CMULT')
            call copich('V', load_name//'.CHME.CIMPO', load_name_loca//'.CHME.CIMPO')
            call jeveuo(load_name_loca//'.CHME.CIMPO.NOLI', 'E',vk24=noli)
            do i=1,size(noli)
                if (noli(i)(1:8).eq.load_name) then
                    noli(i)(1:8)=load_name_loca
                endif
            enddo
            call jeveuo(load_name_loca//'.CHME.CMULT.NOLI', 'E',vk24=noli)
            do i=1,size(noli)
                if (noli(i)(1:8).eq.load_name) then
                    noli(i)(1:8)=load_name_loca
                endif
            enddo
            call jedup1(load_name//'.DUAL.PRDK', 'V', load_name_loca//'.DUAL.PRDK')
            call jedup1(load_name//'.DUAL.PRDI', 'V', load_name_loca//'.DUAL.PRDI')
            call jedup1(load_name//'.DUAL.PRDSO', 'V', load_name_loca//'.DUAL.PRDSO')


            v_load_name(i_load)(1:8)  = load_name_loca
            v_load_name(i_load)(9:16) = load_name
        endif
    end do
!
    call jedema()
!
end subroutine
