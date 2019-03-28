! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine mateReuseMngt(mateOUT  , mateOUT_nb  , mateOUT_list, &
                         mateREUSE, mateREUSE_nb)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indk32.h"
#include "asterfort/utmess.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/getvid.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jedupc.h"
#include "asterfort/jelira.h"
!
character(len=8), intent(in) :: mateOUT
integer, intent(in) :: mateOUT_nb
character(len=32), pointer, intent(in) :: mateOUT_list(:)
character(len=8), intent(out) :: mateREUSE
integer, intent(out) :: mateREUSE_nb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Management of reuse
!
! --------------------------------------------------------------------------------------------------
!
! In  mateOUT          : name of output datastructure (to product)
! In  mateOUT_nb       : number of material factor keywords
! In  mateOUT_list     : list of material factor keywords
! Out mateREUSE        : name of output datastructure (from REUSE)
! Out mateREUSE_nb     : number of material factor keywords (from REUSE)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mate, ind, jnorci, nocc
    character(len=8) :: mateIN
    character(len=32) :: valk(2), nomrc
!
! --------------------------------------------------------------------------------------------------
!
    mateREUSE    = '&&OP0005'
    mateREUSE_nb = 0
    call getvid(' ', 'MATER', scal=mateIN, nbret=nocc)
    if (nocc .ne. 0) then
! ----- Only new materials
        call jeveuo(mateIN//'.MATERIAU.NOMRC', 'L', jnorci)
        call jelira(mateIN//'.MATERIAU.NOMRC', 'LONMAX', mateREUSE_nb)
        do i_mate = 1, mateOUT_nb
            nomrc = mateOUT_list(i_mate)
            ind   = indk32 (zk32(jnorci), nomrc, 1, mateREUSE_nb)
            if (ind .ne. 0) then
                valk(1) = mateIN
                valk(2) = nomrc
                call utmess('F', 'MATERIAL2_9', nk=2, valk=valk)
            endif
        end do
! ----- Copy
        call jedupc('G', mateIN, 1, 'V', mateREUSE, ASTER_FALSE)
        if (mateOUT .eq. mateIN) then
            call jedetc('G', mateIN, 1)
        endif
    endif
!
! - Copy in output datastructure
!
    if (mateREUSE_nb .ne. 0) then
        call jedupc('V', mateREUSE, 1, 'G', mateOUT, ASTER_FALSE)
        call jedetr(mateOUT//'.MATERIAU.NOMRC')
    endif
!
end subroutine
