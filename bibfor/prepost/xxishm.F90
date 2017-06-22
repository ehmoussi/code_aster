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

function xxishm(mailc, mailx, mo)
! person_in_charge: daniele.colombo at ifpen.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "jeveux.h" 
    aster_logical :: xxishm
!
! BUT : POST_CHAM_XFEM : LE RESULTAT A POST-TRAITER EST-IL HM?
!
! OUT XXISHM : VRAI SI LE RESULTAT A POST-TRAITER EST UN RESU HM
!              FAUX SINON
!
!-----------------------------------------------------------------------
    character(len=8) :: k8b, mo
    character(len=16) :: notype, notyp2
    character(len=24) :: mailc, mailx
    integer :: nbmac1, nbmac2
    integer :: jmac, jmail, ima, i, itypel
    integer :: jmax
    aster_logical :: pre1
!-----------------------------------------------------------------------
!
    call jemarq()
!
    notype = ' '
    notyp2 = ' '
!
!     SI IL N'Y A PAS DE MAILLES CLASSIQUES DANS LE MODELE ON PASSE
!     DIRECTEMENT AUX MAILLES XFEM POUR SAVOIR SI ON EST EN HM
    if (mailc .eq. '&&OP0196.MAILC') goto 1
!
    call jeveuo(mailc, 'L', jmac)
    call jelira(mailc, 'LONMAX', nbmac1, k8b)
    call jeveuo(mo//'.MAILLE', 'L', jmail)
!
    do i = 1, nbmac1
!
        ima = zi(jmac-1+i)
!
        itypel = zi(jmail-1+ima)
        call jenuno(jexnum('&CATA.TE.NOMTE', itypel), notype)
    end do
!
  1 continue
!
    call jeveuo(mailx, 'L', jmax)
    call jelira(mailx, 'LONMAX', nbmac2, k8b)
    call jeveuo(mo//'.MAILLE', 'L', jmail)
!
    do i = 1, nbmac2
!
        ima = zi(jmax-1+i)
!
        itypel = zi(jmail-1+ima)
        call jenuno(jexnum('&CATA.TE.NOMTE', itypel), notyp2)
    end do
!
!
    if ((notype(1:2).eq.'HM') .or. (notyp2(1:2).eq.'HM')) then
        pre1=.true.
    else
        pre1=.false.
    endif
!
    xxishm=pre1
!
    call jedema()
end function
