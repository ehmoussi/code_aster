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

subroutine chreco(chou)
    implicit none

!     BUT : TRANSFORMER UN CHAM_NO : COMPLEXE --> REEL

!     LE CHAMP COMPLEXE EST CONSTRUIT DE SORTE QUE:
!    - SA PARTIE REELLE CORRESPOND AUX VALEURS DU CHAMP REEL
!    - SA PARTIE IMAGINAIRE EST NULLE.
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/sdchgd.h"
#include "asterfort/utmess.h"

    integer :: iret, jvale, nbval, jvalin, i
    character(len=3) :: tsca
    character(len=4) :: tych
    character(len=8) :: chou, chin, nomgd, partie
    character(len=24) :: vale, valin
    real(kind=8) :: x, y, c1
!----------------------------------------------------------------------

    call jemarq()

!   -- recuperation du champ complexe
    call getvid(' ', 'CHAM_GD', scal=chin, nbret=iret)

!   -- verification : chin cham_no et complexe ?
    call dismoi('TYPE_CHAMP', chin, 'CHAMP', repk=tych)
    if (tych .ne. 'NOEU')  call utmess('F', 'UTILITAI_37', sk=chin)
    call dismoi('NOM_GD', chin, 'CHAMP', repk=nomgd)
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
    if (tsca .ne. 'C')  call utmess('F', 'UTILITAI_35', sk=chin)

!   -- copie chin --> chou
    call copisd('CHAMP', 'G', chin, chou)


!    modifications de chou:
!    ======================

!   -- 1. ".vale"
!   -------------
    vale=chou
    vale(20:24)='.VALE'

    call jelira(vale, 'LONMAX', nbval)
    call jedetr(vale)
    call jecreo(vale, 'G V R')
    call jeecra(vale, 'LONMAX', nbval)
    call jeveuo(vale, 'E', jvale)

    valin=vale
    valin(1:19)=chin
    call jeveuo(valin, 'L', jvalin)

    call getvtx(' ', 'PARTIE', scal=partie, nbret=iret)

    c1=180.d0/r8pi()
    do i = 1, nbval
        if (partie .eq. 'REEL') then
            zr(jvale+i-1)=dble(zc(jvalin+i-1))
        else if (partie.eq.'IMAG') then
            zr(jvale+i-1)=dimag(zc(jvalin+i-1))
        else if (partie.eq.'MODULE') then
            zr(jvale+i-1)=abs(zc(jvalin+i-1))
        else if (partie.eq.'PHASE') then
            x=dble(zc(jvalin+i-1))
            y=dimag(zc(jvalin+i-1))
            zr(jvale+i-1)=atan2(y,x)*c1
        endif
    end do

!   -- 2. changement de la grandeur
!   --------------------------------
    call sdchgd(chou, 'R')


    call jedema()

end subroutine
