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

subroutine medith(model, list_load, matr_elem)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/wkvect.h"
!
!
    character(len=24), intent(in) :: model
    character(len=19), intent(in) :: list_load
    character(len=24), intent(inout) :: matr_elem
!
! --------------------------------------------------------------------------------------------------
!
! Thermics - Load
!
! Elementary matrix for Dirichlet BC
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  list_load        : name for list of loads
! IO  matr_elem        : elementary matrix
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: nomcha, lpain(1), lpaout(1)
    character(len=16) :: option
    character(len=24) :: ligrch, lchin(1), lchout(1)
    integer :: iret, nb_load, ilires, jmed, i_load, jchar, jinf
    character(len=24) :: lload_name, lload_info
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    call jeexin(lload_name, iret)
    if (iret .eq. 0) then
        goto 99
    endif
    call jelira(lload_name, 'LONMAX', nb_load)
    call jeveuo(lload_name, 'L', jchar)
!
    call jeexin(matr_elem, iret)
    if (iret .eq. 0) then
        matr_elem = '&&METDIR           .RELR'
        call memare('V', matr_elem, model(1:8), ' ', ' ',&
                    'RIGI_THER')
        call wkvect(matr_elem, 'V V K24', nb_load, jmed)
    else
        call jeveuo(matr_elem, 'E', jmed)
    endif
!
    lpaout(1) = 'PMATTTR'
    lchout(1) = matr_elem(1:8)//'.ME001'
!
    if (zk24(jchar) .ne. '        ') then
        ilires = 0
        call jeveuo(lload_info, 'L', jinf)
        do i_load = 1, nb_load
            if (zi(jinf+i_load) .ne. 0) then
                nomcha = zk24(jchar+i_load-1) (1:8)
                ligrch = nomcha//'.CHTH.LIGRE'
!
                call jeexin(nomcha//'.CHTH.LIGRE.LIEL', iret)
                if (iret .le. 0) goto 10
                lchin(1) = nomcha//'.CHTH.CMULT'
                call exisd('CHAMP_GD', nomcha//'.CHTH.CMULT', iret)
                if (iret .le. 0) goto 10
!
                lpain(1) = 'PDDLMUR'
                call codent(ilires+1, 'D0', lchout(1) (12:14))
                option = 'THER_DDLM_R'
                call calcul('S', option, ligrch, 1, lchin,&
                            lpain, 1, lchout, lpaout, 'V',&
                            'OUI')
                zk24(jmed+ilires) = lchout(1)
                ilires = ilires + 1
            endif
10          continue
        end do
        call jeecra(matr_elem, 'LONUTI', ilires)
    endif
!
99  continue
!
    call jedema()
end subroutine
