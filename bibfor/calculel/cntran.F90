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

subroutine cntran(linoeu, nbno, chs1, chs2)
    implicit none
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: linoeu(*), nbno
    character(len=*) :: chs1, chs2
!
!     COMMANDE:  CREA_RESU
!     TRAITEMENT DU MOT CLE FACTEUR "PERM_CHAMP"
!
! ----------------------------------------------------------------------
!
!
!
    integer :: ncmp1, ncmp2, ino1, ino2,    jcn1v, jcn1l
    integer :: icmp1,    jcn2v, jcn2l, icmp2
    character(len=3) :: tsca
    character(len=8) :: nomgd, nomgd2, nocmp
    character(len=19) :: cns1, cns2
    integer, pointer :: cn1d(:) => null()
    integer, pointer :: cn2d(:) => null()
    character(len=8), pointer :: cn1c(:) => null()
    character(len=8), pointer :: cn2c(:) => null()
    character(len=8), pointer :: cn1k(:) => null()
    character(len=8), pointer :: cn2k(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
    cns1 = chs1
    cns2 = chs2
!
    call jeveuo(cns1//'.CNSK', 'L', vk8=cn1k)
    call jeveuo(cns1//'.CNSD', 'L', vi=cn1d)
    call jeveuo(cns1//'.CNSC', 'L', vk8=cn1c)
    call jeveuo(cns1//'.CNSV', 'L', jcn1v)
    call jeveuo(cns1//'.CNSL', 'E', jcn1l)
!
    call jeveuo(cns2//'.CNSK', 'L', vk8=cn2k)
    call jeveuo(cns2//'.CNSD', 'L', vi=cn2d)
    call jeveuo(cns2//'.CNSC', 'L', vk8=cn2c)
    call jeveuo(cns2//'.CNSV', 'E', jcn2v)
    call jeveuo(cns2//'.CNSL', 'E', jcn2l)
!
    nomgd = cn1k(2)
    ncmp1 = cn1d(2)
!
    nomgd2 = cn2k(2)
    ncmp2 = cn2d(2)
!
    ASSERT(nomgd2.eq.nomgd)
!
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
!
    do ino2 = 1, nbno
!
        ino1 = linoeu(ino2)
        if (ino1 .eq. 0) goto 10
!
        do icmp2 = 1, ncmp2
!
            nocmp = cn2c(icmp2)
!
            icmp1 = indik8( cn1c, nocmp, 1, ncmp1 )
            if (icmp1 .eq. 0) goto 20
            if (.not. zl(jcn1l-1+(ino1-1)*ncmp1+icmp1)) goto 20
!
            zl(jcn2l-1+(ino2-1)*ncmp2+icmp2) = .true.
!
            if (tsca .eq. 'R') then
                zr(jcn2v-1+(ino2-1)*ncmp2+icmp2) = zr( jcn1v-1+(ino1-1 ) *ncmp1+icmp1 )
            else if (tsca.eq.'C') then
                zc(jcn2v-1+(ino2-1)*ncmp2+icmp2) = zc( jcn1v-1+(ino1-1 ) *ncmp1+icmp1 )
            else if (tsca.eq.'I') then
                zi(jcn2v-1+(ino2-1)*ncmp2+icmp2) = zi( jcn1v-1+(ino1-1 ) *ncmp1+icmp1 )
            else if (tsca.eq.'L') then
                zl(jcn2v-1+(ino2-1)*ncmp2+icmp2) = zl( jcn1v-1+(ino1-1 ) *ncmp1+icmp1 )
            else if (tsca.eq.'K8') then
                zk8(jcn2v-1+(ino2-1)*ncmp2+icmp2) = zk8( jcn1v-1+(ino1- 1 )*ncmp1+icmp1 )
            else
                ASSERT(.false.)
            endif
!
 20         continue
        end do
!
 10     continue
    end do
!
    call jedema()
end subroutine
