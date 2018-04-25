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
subroutine dismca(question_, object_, answeri, answerk_, ierd)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/fonbpa.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
character(len=*), intent(in) :: question_
character(len=*), intent(in) :: object_
integer, intent(out) :: answeri, ierd
character(len=*), intent(out)  :: answerk_
!
! --------------------------------------------------------------------------------------------------
!
! The DISMOI mechanism
!
! Questions for <CARTE> objects
!
! --------------------------------------------------------------------------------------------------
!
! In  question       : question on object
! In  object         : name of object
! Out answeri        : answer when integer
! Out answerk        : answer when string
! Out ierd           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: question
    character(len=32) :: answerk
    character(len=19) :: object, func_name, field
    character(len=8) ::  func_type, para_name(10), type, nogd
    integer ::  iexi, iret
    integer :: jvale, i_zone, i_para, nb_zone, ltyp, nb_para
    integer, pointer :: v_desc(:) => null()
    character(len=24), pointer :: v_prol(:) => null()
    character(len=8), pointer :: v_noma(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    answerk_ = ' '
    answeri  = 0
    ierd     = 0
    object   = object_
    question = question_
!
! - Object exists ?
!
    call jeexin(object//'.NOMA', iexi)
    if (iexi .eq. 0) then
        ierd = 1
        goto 999
    endif
!
    if (question .eq. 'NOM_MAILLA') then
        call jeveuo(object//'.NOMA', 'L', vk8=v_noma)
        answerk = v_noma(1)
!
    else if (question .eq. 'TYPE_CHAMP') then
        answerk = 'CART'
!
    else if (question .eq. 'TYPE_SUPERVIS') then
        call jeveuo(object//'.DESC', 'L', vi=v_desc)
        call jenuno(jexnum('&CATA.GD.NOMGD', v_desc(1)), nogd)
        answerk = 'CART_'//nogd
!
    else if (question(1:7) .eq. 'NOM_GD ') then
        call jeveuo(object//'.DESC', 'L', vi=v_desc)
        call jenuno(jexnum('&CATA.GD.NOMGD', v_desc(1)), answerk)
!
    else if (question .eq. 'PARA_INST') then
        answerk = ' '
        field   = object
        call jeveuo(field//'.VALE', 'L', jvale)
        call jelira(field//'.VALE', 'TYPE', cval=type)
        if (type(1:1) .eq. 'K') then
            call jelira(field//'.VALE', 'LONMAX', nb_zone)
            call jelira(field//'.VALE', 'LTYP', ltyp)
            do i_zone = 1, nb_zone
                if (ltyp .eq. 8) then
                    func_name = zk8(jvale+i_zone-1)
                else if (ltyp .eq. 24) then
                    func_name = zk24(jvale+i_zone-1)(1:19)
                else
                    ASSERT(.false.)
                endif
                if (func_name(1:8) .ne. ' ') then
                    call jeexin(func_name//'.PROL', iret)
                    if (iret .gt. 0) then
                        call jeveuo(func_name//'.PROL', 'L', vk24=v_prol)
                        call fonbpa(func_name, v_prol, func_type, 10, nb_para,&
                                    para_name)
                        do i_para = 1, nb_para
                            if (para_name(i_para)(1:4) .eq. 'INST') then
                                answerk = 'OUI'
                                goto 11
                            endif
                        end do
                    endif
                endif
            end do
11          continue
        endif
!
    else if (question .eq. 'PARA_VITE') then
        answerk = ' '
        field   = object
        call jeveuo(field//'.VALE', 'L', jvale)
        call jelira(field//'.VALE', 'TYPE', cval=type)
        if (type(1:1) .eq. 'K') then
            call jelira(field//'.VALE', 'LONMAX', nb_zone)
            call jelira(field//'.VALE', 'LTYP', ltyp)
            do i_zone = 1, nb_zone
                if (ltyp .eq. 8) then
                    func_name = zk8(jvale+i_zone-1)
                else if (ltyp .eq. 24) then
                    func_name = zk24(jvale+i_zone-1)(1:19)
                else
                    ASSERT(.false.)
                endif
                if (func_name(1:8) .ne. ' ') then
                    call jeexin(func_name//'.PROL', iret)
                    if (iret .gt. 0) then
                        call jeveuo(func_name//'.PROL', 'L', vk24=v_prol)
                        call fonbpa(func_name, v_prol, func_type, 10, nb_para,&
                                    para_name)
                        do i_para = 1, nb_para
                            if (para_name(i_para) .eq. 'VITE_X' .or.&
                                para_name(i_para) .eq. 'VITE_Y' .or.&
                                para_name(i_para) .eq. 'VITE_Z') then
                                answerk = 'OUI'
                                goto 12
                            endif
                        end do
                    endif
                endif
            end do
12          continue
        endif
    else
        ierd = 1
    endif
!
999 continue
!
    answerk_ = answerk
    call jedema()
end subroutine
