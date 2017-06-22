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

function nbcmp(gd)
    implicit none
    integer :: nbcmp
!
!
!     RETOURNE LE NOMBRE D ENTIERS CODES POUR UN GRANDEUR DU TYPE :
!     _SIMPLE
!     _ELEMENTAIRE
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: gd, code
    character(len=8) :: nomgd, nomgd1, nomgd2
!     INCLUDE($FUNJEV)
!
!     FONCTIONS JEVEUX
!
!
!
    integer :: vali(3)
    character(len=32) :: valk(3)
!
!     EXCLUDE($FUNJEV)
!
!
!-----------------------------------------------------------------------
    integer :: iddgd, igd1, igd2
!-----------------------------------------------------------------------
    call jemarq()
    nbcmp=0
!
    call jeveuo(jexnum('&CATA.GD.DESCRIGD', gd), 'L', iddgd)
    code = zi(iddgd)
    if ((code.eq.1) .or. (code.eq.2)) then
        call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', nbcmp)
        goto 9999
    else if (code.eq.3) then
        igd1 = zi(iddgd+3)
        if (igd1 .gt. 0) then
            call jelira(jexnum('&CATA.GD.NOMCMP', igd1), 'LONMAX', nbcmp)
            goto 9999
        else
            call jenuno(jexnum('&CATA.GD.DESCRIGD', gd), nomgd)
            valk (1) = 'GRANDEUR LIGNE REFERENCEE PAR'
            valk (2) = nomgd//' NULLE'
            vali (1) = gd
            call utmess('F', 'CALCULEL6_17', nk=2, valk=valk, si=vali(1))
        endif
    else if ((code.eq.4) .or. (code.eq.5)) then
        igd1 = zi(iddgd+3)
        if (igd1 .eq. 0) then
            call jenuno(jexnum('&CATA.GD.DESCRIGD', gd), nomgd)
            valk (1) = 'GRANDEUR LIGNE REFERENCEE PAR'
            valk (2) = nomgd//' NULLE'
            vali (1) = gd
            call utmess('F', 'CALCULEL6_17', nk=2, valk=valk, si=vali(1))
        endif
        igd2 = zi(iddgd+4)
        if (igd2 .eq. 0) then
            call jenuno(jexnum('&CATA.GD.DESCRIGD', gd), nomgd)
            valk (1) = 'GRANDEUR COLONNE REFERENCEE PAR'
            valk (2) = nomgd//' NULLE'
            vali (1) = gd
            call utmess('F', 'CALCULEL6_17', nk=2, valk=valk, si=vali(1))
        endif
        if (igd1 .ne. igd2) then
            call jenuno(jexnum('&CATA.GD.DESCRIGD', gd), nomgd)
            call jenuno(jexnum('&CATA.GD.DESCRIGD', igd1), nomgd1)
            call jenuno(jexnum('&CATA.GD.DESCRIGD', igd2), nomgd2)
            vali (1) = igd1
            vali (2) = igd2
            vali (3) = gd
            valk (1) = nomgd1//' /= '
            valk (2) = nomgd2
            valk (3) = nomgd
            call utmess('F', 'CALCULEL6_20', nk=3, valk=valk, ni=3,&
                        vali=vali)
        endif
        call jelira(jexnum('&CATA.GD.NOMCMP', igd1), 'LONMAX', nbcmp)
        goto 9999
    else
        vali (1) = gd
        vali (2) = code
        call utmess('F', 'CALCULEL6_21', ni=2, vali=vali)
    endif
9999  continue
    call jedema()
end function
