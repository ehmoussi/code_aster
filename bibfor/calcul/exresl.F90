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

subroutine exresl(modatt, iparg, chin)

use calcul_module, only : ca_iachii_, ca_iachlo_, ca_iawlo2_, ca_igr_,&
     ca_iichin_, ca_ilchlo_, ca_nbelgr_, ca_nbgr_, ca_typegd_,&
     ca_lparal_, ca_paral_, ca_iel_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/digde2.h"
#include "asterfort/jacopo.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"

    integer :: modatt, iparg
    character(len=19) :: chin
!----------------------------------------------------------------------
!     Entrees:
!        modatt : mode local attendu
!        iparg  : numero du parametre dans l'option
!        chin   : nom du champ global sur lequel on fait l'extraction
!----------------------------------------------------------------------
    integer :: desc, mode, ncmpel, iaux1, iaux2, iaux0, k
    integer :: jresl, debugr, lggrel
!----------------------------------------------------------------------


    call jemarq()

    lggrel=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+4)
    debugr=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+5)

    desc=zi(ca_iachii_-1+11*(ca_iichin_-1)+4)

    ASSERT(modatt.gt.0)
    mode=zi(desc-1+2+ca_igr_)

    if (mode .eq. 0) then
!       -- le resuelem n'existe pas sur le grel :
!          on sort sans mettre zl(ilchlo+debugr-1-1+k)=.true.
!          on aura alors toujours iret=3 avec tecach
        goto 999
    endif

    ASSERT(mode.eq.modatt)
    ncmpel=digde2(mode)
    ASSERT(lggrel.eq.ncmpel*ca_nbelgr_)
    call jeveuo(jexnum(chin//'.RESL', ca_igr_), 'L', jresl)
    if (ca_lparal_) then
        do ca_iel_ = 1, ca_nbelgr_
            if (ca_paral_(ca_iel_)) then
                iaux0=(ca_iel_-1)*ncmpel
                iaux1=jresl+iaux0
                iaux2=ca_iachlo_+debugr-1+iaux0
                call jacopo(ncmpel, ca_typegd_, iaux1, iaux2)
            endif
        enddo
    else
        call jacopo(lggrel, ca_typegd_, jresl, ca_iachlo_+debugr-1)
    endif


    if (ca_lparal_) then
        do ca_iel_ = 1, ca_nbelgr_
            if (ca_paral_(ca_iel_)) then
                iaux1=ca_ilchlo_+debugr-1+(ca_iel_-1)*ncmpel
                do k = 1, ncmpel
                    zl(iaux1-1+k)=.true.
                enddo
            endif
        enddo
    else
        do k = 1, lggrel
            zl(ca_ilchlo_+debugr-1-1+k)=.true.
        enddo
    endif

999 continue
    call jedema()
end subroutine
