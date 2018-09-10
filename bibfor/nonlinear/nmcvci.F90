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

subroutine nmcvci(charge, infoch, fomult, numedd, depmoi,&
                  instap, cncine)

    implicit none
!
!
! BUT : CALCULER LE CHAM_NO CNCINE QUI CONTIENT  L'INCREMENT DE
!       DEPLACEMENT IMPOSE PAR LES CHARGES CINEMATIQUES.
!       POUR CELA, ON FAIT LA DIFFERENCE ENTRE LES INSTANTS "+" ET "-"
!       MAIS POUR L'INSTANT "-", IL FAUT PARTIR DU "VRAI" CHAMP
!       DE DEPLACEMENT.
!----------------------------------------------------------------------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/ascavc.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/vtcmbl.h"
#include "asterfort/vtcreb.h"
    character(len=24) :: charge, infoch, fomult, numedd
    character(len=19) :: depmoi, cncine
    character(len=24) :: l2cnci(2), cncinm, cncinp
    character(len=8) :: char1
    real(kind=8) :: instap, coefr(2)
    integer :: neq, ieq, neq2, iret, jinfc, ichar
    integer :: nbchar, jlchar
    character(len=1) :: typch(2)
    aster_logical :: lvcine
    integer, pointer :: dlci(:) => null()
    real(kind=8), pointer :: cncim(:) => null()
    real(kind=8), pointer :: vale(:) => null()
!----------------------------------------------------------------------
!
    call jemarq()
!
!     -- CREATION DE CNCINE = 0. PARTOUT :
!     --------------------------------------
    call exisd('CHAMP_GD', cncine, iret)
    if (iret .eq. 0) then
        call vtcreb(cncine, 'V', 'R', nume_ddlz = numedd, nb_equa_outz = neq)
    endif    
    call jelira(cncine(1:19)//'.VALE', 'LONMAX', ival=neq)
    call jelira(depmoi(1:19)//'.VALE', 'LONMAX', ival=neq2)
    ASSERT(neq.eq.neq2)
    call jeveuo(cncine(1:19)//'.VALE', 'E', vr=vale)
!
!
!     -- Y-A-T-IL DES CHARGES CINEMATIQUES ?
!     -----------------------------------------------------------------
    lvcine=.false.
    call jeveuo(infoch, 'L', jinfc)
    do ichar = 1, zi(jinfc)
        if (zi(jinfc+ichar) .lt. 0) lvcine=.true.
    end do
!
!     -- Y-A-T-IL DES CHARGES CONTENANT DES CHARGES CINEMATIQUES ?
!     -----------------------------------------------------------------
    call jeveuo(charge, 'L', jlchar)
    call jelira(charge, 'LONMAX', ival=nbchar)
    do ichar = 1, nbchar
        char1=zk24(jlchar-1+ichar)(1:8)
    end do
!
!     -- S'IL N'Y A PAS DE CHARGES CINEMATIQUES, IL N'Y A RIEN A FAIRE:
!     -----------------------------------------------------------------
    if (.not.lvcine) goto 999
!
!
!     -- S'IL Y A DES CHARGES CINEMATIQUES :
!     -----------------------------------------------------------------
    cncinm='&&NMCHAR.CNCIMM'
    cncinp='&&NMCHAR.CNCIMP'
!
!
!     CALCUL DE UIMP+ :
!     ---------------------
    call ascavc(charge, infoch, fomult, numedd, instap,&
                cncinp)
    call jeveuo(cncinp(1:19)//'.DLCI', 'L', vi=dlci)
!
!
!     CALCUL DE UIMP- : C'EST U- LA OU ON IMPOSE LE DEPLACEMENT
!                       ET 0. AILLEURS
!     ---------------------------------------------------------
    call copisd('CHAMP_GD', 'V', depmoi, cncinm)
    call jeveuo(cncinm(1:19)//'.VALE', 'E', vr=cncim)
    do ieq = 1, neq
        if (dlci(ieq) .eq. 0) then
            cncim(ieq)=0.d0
        endif
    end do
!
!     DIFFERENCE UIMP+ - UIMP- :
!     ---------------------------
    coefr(1)=-1.d0
    coefr(2)=+1.d0
    l2cnci(1)=cncinm
    l2cnci(2)=cncinp
    typch(1)='R'
    typch(2)='R'
    call vtcmbl(2, typch, coefr, typch, l2cnci,&
                typch(1), cncine)
!
!     MENAGE :
!     ---------
    call detrsd('CHAM_NO', cncinm)
    call detrsd('CHAM_NO', cncinp)
!
999 continue
    call jedema()
!
end subroutine
