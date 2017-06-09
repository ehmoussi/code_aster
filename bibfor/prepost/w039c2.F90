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

subroutine w039c2(nuzone, jvale, jdesc, nomgd, ifm,&
                  ifr)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
!
    integer :: nuzone, jvale, jdesc, ifm, ifr
    character(len=8) :: nomgd
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!     BUT: IMPRIMER LA"LEGENDE" POUR W039C1
! ----------------------------------------------------------------------
!
!
!
!
    integer :: nec, ncmpmx, kcmp, jcmp, nzonmx, dec1, ico, debgd
    character(len=8) :: tsca, nocmp
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call dismoi('NB_EC', nomgd, 'GRANDEUR', repi=nec)
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
    call jelira(jexnom('&CATA.GD.NOMCMP', nomgd), 'LONMAX', ncmpmx)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgd), 'L', jcmp)
    ASSERT(nuzone.gt.0)
    nzonmx=zi(jdesc-1+2)
!
    write (ifm,1005)'VALEUR =',dble(nuzone)
    write (ifr,1005)'VALEUR =',dble(nuzone)
    debgd=3+2*nzonmx+(nuzone-1)*nec+1
    ico=0
    do kcmp = 1, ncmpmx
        if (exisdg(zi(jdesc-1+debgd),kcmp)) then
            ico=ico+1
            nocmp=zk8(jcmp-1+kcmp)
            dec1=ncmpmx*(nuzone-1)+ico
            if (tsca .eq. 'K8') then
                write (ifm,1004)nocmp,'=',zk8(jvale-1+dec1)
                write (ifr,1004)nocmp,'=',zk8(jvale-1+dec1)
            else if (tsca.eq.'K16') then
                write (ifm,1004)nocmp,'=',zk16(jvale-1+dec1)
                write (ifr,1004)nocmp,'=',zk16(jvale-1+dec1)
            else if (tsca.eq.'K24') then
                write (ifm,1004)nocmp,'=',zk24(jvale-1+dec1)
                write (ifr,1004)nocmp,'=',zk24(jvale-1+dec1)
            else if (tsca.eq.'I') then
                write (ifm,1003)nocmp,'=',zi(jvale-1+dec1)
                write (ifr,1003)nocmp,'=',zi(jvale-1+dec1)
            else if (tsca.eq.'R') then
                write (ifm,1001)nocmp,'=',zr(jvale-1+dec1)
                write (ifr,1001)nocmp,'=',zr(jvale-1+dec1)
            else if (tsca.eq.'C') then
                write (ifm,1002)nocmp,'=',dble(zc(jvale-1+dec1)),&
                dimag(zc(jvale-1+dec1))
                write (ifr,1002)nocmp,'=',dble(zc(jvale-1+dec1)),&
                dimag(zc(jvale-1+dec1))
            else
                ASSERT(.false.)
            endif
        endif
    end do
!
    1001 format (4x,a8,1x,a1,1x,1pd11.3)
    1002 format (4x,a8,1x,a1,1x,2(1pd11.3))
    1003 format (4x,a8,1x,a1,1x,i8)
    1004 format (4x,a8,1x,a1,1x,a)
    1005 format (a,1x,1f11.0)
    call jedema()
end subroutine
