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

subroutine cpclma(nomain, nomaou, typcol, base)
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    character(len=1) :: base
    character(len=8) :: nomain, nomaou, typcol
!
! person_in_charge: nicolas.sellenet at edf.fr
!
#include "jeveux.h"
!
!   But :  Recopie des collections .GROUPEMA ET .GROUPENO
!
    integer :: nbgmai, igroup, jnuma1, jnuma2, nbmail, jmaill
    integer :: codret
!
    character(len=24) :: grmain, grmaou, ptnmou, nomgrp
!------------------------------------------------------------------------
!
    call jemarq()
!
    if (typcol .eq. 'GROUPEMA') then
        grmain = nomain//'.GROUPEMA'
        grmaou = nomaou//'.GROUPEMA'
        ptnmou = nomaou//'.PTRNOMMAI'
    else if (typcol.eq.'GROUPENO') then
        grmain = nomain//'.GROUPENO'
        grmaou = nomaou//'.GROUPENO'
        ptnmou = nomaou//'.PTRNOMNOE'
    else
        ASSERT(.false.)
    endif
!
    call jedetr(grmaou)
    call jedetr(ptnmou)
!
    call jeexin(grmain, codret)
    if (codret .eq. 0) goto 999

    call jelira(grmain, 'NOMUTI', nbgmai)
    call jecreo(ptnmou, base//' N K24')
    call jeecra(ptnmou, 'NOMMAX', nbgmai)
    call jecrec(grmaou, base//' V I', 'NO '//ptnmou, 'DISPERSE', 'VARIABLE',&
                nbgmai)
!
    do 10 igroup = 1, nbgmai
        call jenuno(jexnum(grmain, igroup), nomgrp)
        call jecroc(jexnom(grmaou, nomgrp))
        call jeveuo(jexnum(grmain, igroup), 'L', jnuma1)
        call jelira(jexnum(grmain, igroup), 'LONUTI', nbmail)
        call jeecra(jexnom(grmaou, nomgrp), 'LONMAX', max(nbmail,1))
        call jeecra(jexnom(grmaou, nomgrp), 'LONUTI', nbmail)
        call jeveuo(jexnom(grmaou, nomgrp), 'E', jnuma2)
        do 20 jmaill = 0, nbmail-1
            zi(jnuma2+jmaill) = zi(jnuma1+jmaill)
20      continue
10  end do
!
999  continue
!
    call jedema()
!
end subroutine
