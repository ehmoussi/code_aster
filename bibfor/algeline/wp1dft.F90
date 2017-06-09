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

subroutine wp1dft(lmat, imode, zeropo, z, detnor,&
                  det, idet, isturm)
    implicit none
#include "jeveux.h"
#include "asterfort/almulr.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: lmat, imode, idet
    complex(kind=8) :: zeropo(*), z, detnor
    real(kind=8) :: det
    real(kind=8) :: un, zero, dist
    character(len=24) :: nomdia
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iret, isturm, ldiag, neq
!-----------------------------------------------------------------------
    data  nomdia/'                   .DIGS'/
!
    call jemarq()
    un = 1.d0
    zero = 0.d0
!
!     --- PRELIMINAIRE ---
    nomdia(1:19) = zk24(zi(lmat+1))
    neq = zi(lmat+2 )
    call jeexin(nomdia, iret)
    if (iret .eq. 0) then
        call utmess('F', 'MODELISA2_9', sk=nomdia)
    endif
    call jeveuo(nomdia, 'L', ldiag)
    ldiag=ldiag+neq
!
!
!     --- CALCUL DE LA DEFLATION ---
    detnor = dcmplx(un,zero)
    do 1 i = 1, imode-1
        detnor = detnor / ( (z-zeropo(i))*(z-dconjg(zeropo(i))) )
 1  end do
!
!     --- CALCUL DU DETERMINANT DE LA MATRICE DEFLATEE ---
    det = un
    idet = 0
    isturm = 0
    do 33 i = ldiag, ldiag+neq-1
        dist = sqrt(dble(zc(i)*dconjg(zc(i))))
        detnor = detnor * zc(i) / dist
        if (dble(zc(i)) .lt. zero) isturm = isturm + 1
        call almulr('CUMUL', [dist], 1, det, idet)
33  end do
    call jedetr(nomdia)
    call jedema()
end subroutine
