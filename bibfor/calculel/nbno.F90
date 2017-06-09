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

function nbno(mode)
    implicit none
    integer :: nbno
!
!     BUT: TROUVER LE NOMBRE DE NOEUDS ASSOCIES A UN MODE_LOCAL
!     DE TYPE CHAM_NO, VECTEUR, OU MATRICE .
!
!     IN:  MODE : MODE_LOCAL
!     OUT: NBNO : NOMBRE DE NOEUDS
!
!
! ---------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: mode, m1, m2, n1, n2
!
!     FONCTIONS JEVEUX
!
!
!
!
!-----------------------------------------------------------------------
    integer :: iadm, iadm1, iadm2, ischn, ismat
!-----------------------------------------------------------------------
    call jemarq()
    ismat = 0
    ischn = 0
    call jeveuo(jexnum('&CATA.TE.MODELOC', mode), 'L', iadm)
!
    if (zi(iadm) .eq. 4) then
    else if (zi(iadm).eq.5) then
        ismat = 1
    else if (zi(iadm).eq.2) then
        ischn = 1
    else
        call utmess('F', 'CALCULEL3_81')
    endif
!
    if (ischn .eq. 1) then
        nbno = zi(iadm-1+4)
        if (nbno .gt. 10000) nbno = nbno - 10000
        goto 9999
    endif
!
    m1 = zi(iadm+3)
    call jeveuo(jexnum('&CATA.TE.MODELOC', m1), 'L', iadm1)
    n1 = zi(iadm1+3)
    n1 = abs(n1)
    if (n1 .gt. 10000) then
        n1 = n1 - 10000
    endif
!
    if (ismat .eq. 1) then
        m2 = zi(iadm+4)
        call jeveuo(jexnum('&CATA.TE.MODELOC', m2), 'L', iadm2)
        n2 = zi(iadm2+3)
        n2 = abs(n2)
        if (n2 .gt. 10000) then
            n2 = n2 - 10000
        endif
        if (n1 .ne. n2) then
            call utmess('F', 'CALCULEL3_82')
        endif
    endif
    nbno = n1
9999  continue
    call jedema()
end function
