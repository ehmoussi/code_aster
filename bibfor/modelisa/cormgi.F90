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

subroutine cormgi(basez, ligrez)
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedup1.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
!
    character(len=*) :: basez, ligrez
    character(len=1) :: base
    character(len=19) :: ligrel
!
!**********************************************************************
!
!   OPERATION REALISEE
!   ------------------
!     CREATION DE L' OBJET .REPE DANS LA SD DE LIGREL
!
!     LIGREL.REPE : OJB V I LONG=2*NB_MAILLE(MAILLAGE)
!        V(2*(I-1)+1) --> NUMERO DU GREL CONTENANT LA MAILLE NUMERO I
!        V(2*(I-1)+2) --> NUMERO LOCAL DE CETTE MAILLE DANS LE GREL
!
!     REMARQUE : L'OBJET .REPE N'EST CREE QUE SI IL EXISTE DES MAILLES
!     DU MAILLAGE PORTANT UN ELEMENT FINI DANS LE LIGREL (.LIEL)
!
!**********************************************************************
!
    character(len=8) :: nmaila
    integer :: i, j, pt, nbmail, nbgrel, iret
    integer :: jrepe, jgrel, nbmgre
    aster_logical :: exima
!
!
!
    character(len=19) :: ligtmp
    character(len=8), pointer :: lgrf(:) => null()
!
    call jemarq()
    base = basez
    ligrel = ligrez
    ligtmp = '&&CORMGI.LIGREL'
    call jedetr(ligrel//'.REPE')
!
!
    call jeveuo(ligrel//'.LGRF', 'L', vk8=lgrf)
    nmaila = lgrf(1)
    ASSERT(nmaila.ne.' ')
!
    call jeexin(nmaila//'.CONNEX', iret)
    if (iret .eq. 0) then
        goto 999
    endif
!
    call jelira(nmaila//'.CONNEX', 'NMAXOC', nbmail)
    call jeexin(ligrel//'.LIEL', iret)
    if (iret .eq. 0) then
        call utmess('F', 'MODELE1_5')
    endif
    call jelira(ligrel//'.LIEL', 'NUTIOC', nbgrel)
    if (nbmail*nbgrel .eq. 0) then
        goto 999
    endif
!
    call wkvect(ligtmp//'.REPE', 'V V I', 2*nbmail, jrepe)
!
    exima=.false.
    do i = 1, nbgrel, 1
        call jelira(jexnum(ligrel//'.LIEL', i), 'LONMAX', nbmgre)
        call jeveuo(jexnum(ligrel//'.LIEL', i), 'L', jgrel)
        do j = 1, nbmgre - 1, 1
            if (zi(jgrel+j-1) .gt. 0) then
                exima=.true.
                pt = 2* (zi(jgrel+j-1)-1) + 1
                zi(jrepe+pt-1) = i
                zi(jrepe+pt) = j
            endif
        end do
    end do
!
!     -- .REPE N'EXISTE VRAIMENT QUE SI DES MAILLES DU MAILLAGE
!         SONT AFFECTEES
    if (exima) then
        call jedup1(ligtmp//'.REPE', base, ligrel//'.REPE')
    endif
!
!
999 continue
    call jedetr(ligtmp//'.REPE')
!
    call jedema()
end subroutine
