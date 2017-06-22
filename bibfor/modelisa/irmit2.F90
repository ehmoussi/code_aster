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

subroutine irmit2(nbmode, ifmis, freq, tabrig)
! aslint: disable=
    implicit none
!
#include "jeveux.h"
!
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=24) :: tabrig, tabfrq, tabri2, tabri0
    real(kind=8) :: a(3), nins2
!      INTEGER*8    LONG1,LONG2,LONG3
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, i1, ic, ifmis, ifreq, jfrq, jri0
    integer :: jri2, jrig, nbmode, nfreq
    real(kind=8) :: freq, pas
!-----------------------------------------------------------------------
    call jemarq()
!
!
    tabri2 = '&&IRMIT2.RIG2'
    tabri0 = '&&IRMIT2.RIG0'
    tabfrq = '&&IRMIT2.FREQ'
    call wkvect(tabri2, 'V V R', nbmode, jri2)
    call wkvect(tabri0, 'V V R', nbmode, jri0)
    rewind ifmis
!
!   Lecture d'entiers INTEGER*8 en binaire venant de MISS3D
!   On convertit ensuite en INTEGER (*4 sur machine 32 bits, sinon *8).
!   Les reels ne posent pas de probleme : ce sont toujours des REAL*8
!
    read(ifmis,*) nins2,pas
    nfreq=int(nins2)
    call wkvect(tabfrq, 'V V R', nfreq, jfrq)
!      NBMODE=LONG2
!      N1=LONG3
    ic=1
    call jeveuo(tabrig, 'E', jrig)
    do 1 i = 1, nfreq
        zr(jfrq+i-1) = (i-1)*pas
 1  end do
!      READ(IFMIS) (ZR(JFRQ+IFR-1),IFR=1,NFREQ)
    do 3 i = 1, nfreq
        a(1) = zr(jfrq+i-1)
        if (freq .le. (a(1) + r8prem( ))) then
            ifreq = i
            if (i .gt. 1 .and. freq .lt. (a(1) - r8prem( ))) then
                ifreq = ifreq-1
            endif
            if (freq .le. r8prem( )) ic = 2
            if (i .eq. 1 .and. nfreq .eq. 1) ic = 0
            if (i .eq. nfreq .and. freq .ge. (a(1) - r8prem( ))) then
                ic = 0
                ifreq = nfreq
            endif
            goto 7
        endif
 3  end do
    ifreq = nfreq
    ic = 0
 7  continue
    do 5 i = 1, ifreq-1
        read(ifmis,*) a(1)
        read(ifmis,1000) (zr(jri0+i1-1),i1=1,nbmode)
 5  end do
    read(ifmis,*) a(1)
    read(ifmis,1000) (zr(jrig+i1-1),i1=1,nbmode)
    if (ic .ge. 1) then
        read(ifmis,*) a(1)
        read(ifmis,1000) (zr(jri2+i1-1),i1=1,nbmode)
        do 8 i1 = 1, nbmode
            zr(jrig+i1-1) = zr(jrig+i1-1) + (freq-zr(jfrq+ifreq-1))/( zr(jfrq+ifreq)-zr(jfrq+ifre&
                            &q-1)) * (zr(jri2+i1-1)-zr(jrig+ i1-1))
 8      continue
    endif
!
    call jedetr(tabri0)
    call jedetr(tabri2)
    call jedetr(tabfrq)
!
    1000 format((6(1x,1pe13.6)))
    call jedema()
end subroutine
