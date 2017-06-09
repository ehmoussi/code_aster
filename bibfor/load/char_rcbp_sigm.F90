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

subroutine char_rcbp_sigm(cabl_prec, iocc, nbchs, jlces, jll,&
                          jlr)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbexve.h"
#include "asterfort/utmess.h"
!
!
    character(len=8), intent(in) :: cabl_prec
    integer, intent(in) :: iocc
    integer, intent(inout) :: nbchs
    integer, intent(in) :: jlces
    integer, intent(in) :: jll
    integer, intent(in) :: jlr
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! RELA_CINE_BP - Combine stresses
!
! --------------------------------------------------------------------------------------------------
!
! In  cabl_prec       : prestress information from CABLE_BP
! In  iocc            : numero d'occurence
! I/O nbchs           : nombres de champs a fusionner
!
! --------------------------------------------------------------------------------------------------
!
    character(len=4) :: chen
    character(len=8) :: k8bid
    character(len=19) :: cabl_sigm_read, tabl2, lisnom
    integer :: iret
    integer :: nbnom, jlsnom
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - on interdit ADHERENT = NON de DEFI_CABLE_BP dans ce cas
!
    call ltnotb(cabl_prec, 'CABLE_GL', tabl2)
    lisnom = '&&CAPREC.ADHERENT'
    call tbexve(tabl2, 'ADHERENT', lisnom, 'V', nbnom,&
                k8bid)
    call jeveuo(lisnom, 'L', jlsnom)
    if (zk8(jlsnom)(1:3) .eq. 'NON') then
        call utmess('F', 'MODELISA3_38')
    endif
    call jedetr(lisnom)
!
! - Transformation de la carte en champ
!
    cabl_sigm_read = cabl_prec//'.CHME.SIGIN'
    call jeexin(cabl_sigm_read//'.DESC', iret)
    if (iret .eq. 0) then
        call utmess('F', 'CHARGES2_49', sk=cabl_prec)
    endif
!
    ASSERT(nbchs.lt.10000)
    call codent(nbchs, 'D0', chen)
    call carces(cabl_sigm_read, 'ELEM', ' ', 'V', '&&CAPREC.CES'// chen,&
                'A', iret)
    zk16(jlces+iocc-1)='&&CAPREC.CES'//chen
    zr(jlr+iocc-1)=1.d0
    zl(jll+iocc-1)=.true.
    nbchs=nbchs+1
    call jelibe(cabl_sigm_read//'.DESC')
    call jelibe(cabl_sigm_read//'.VALE')
    call jedetc('V', cabl_sigm_read, 1)
!
    call jedema()
end subroutine
