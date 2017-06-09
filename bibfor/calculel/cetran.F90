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

subroutine cetran(lima1, lima2, nbma, chs1, chs2)
    implicit none
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: lima1(*), lima2(*), nbma
    character(len=*) :: chs1, chs2
!
!     COMMANDE:  CREA_RESU
!     TRAITEMENT DU MOT CLE FACTEUR "PERM_CHAMP"
!
! ----------------------------------------------------------------------
!
!
!
    integer :: nbpt, nbpt2, nbsp, nbsp2, ncmp1, ncmp2, ipt, isp, iad1
    integer :: iad2,  jce1d,  jce1v, jce1l, icmp1,  jce2d
    integer ::  jce2v, jce2l, icmp2, ima, ima1, ima2
    character(len=3) :: tsca
    character(len=8) :: nomgd, nomgd2, nocmp
    character(len=19) :: ces1, ces2
    character(len=8), pointer :: ce1k(:) => null()
    character(len=8), pointer :: ce2k(:) => null()
    character(len=8), pointer :: ce1c(:) => null()
    character(len=8), pointer :: ce2c(:) => null()
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
    ces1 = chs1
    ces2 = chs2
!
    call jeveuo(ces1//'.CESK', 'L', vk8=ce1k)
    call jeveuo(ces1//'.CESD', 'L', jce1d)
    call jeveuo(ces1//'.CESC', 'L', vk8=ce1c)
    call jeveuo(ces1//'.CESV', 'L', jce1v)
    call jeveuo(ces1//'.CESL', 'L', jce1l)
!
    call jeveuo(ces2//'.CESK', 'L', vk8=ce2k)
    call jeveuo(ces2//'.CESD', 'L', jce2d)
    call jeveuo(ces2//'.CESC', 'L', vk8=ce2c)
    call jeveuo(ces2//'.CESV', 'E', jce2v)
    call jeveuo(ces2//'.CESL', 'E', jce2l)
!
    nomgd = ce1k(2)
    ncmp1 = zi(jce1d-1+2)
!
    nomgd2 = ce2k(2)
    ncmp2 = zi(jce2d-1+2)
!
    ASSERT(nomgd2.eq.nomgd)
!
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
!
    do ima = 1, nbma
!
        ima1 = lima1(ima)
        ima2 = lima2(ima)
!
        nbpt = zi(jce1d-1+5+4*(ima1-1)+1)
        nbsp = zi(jce1d-1+5+4*(ima1-1)+2)
!
        nbpt2 = zi(jce2d-1+5+4*(ima2-1)+1)
        nbsp2 = zi(jce2d-1+5+4*(ima2-1)+2)
        ASSERT(nbpt2.eq.nbpt)
        ASSERT(nbsp2.eq.nbsp)
!
        do icmp2 = 1, ncmp2
!
            nocmp = ce2c(icmp2)
!
            icmp1 = indik8( ce1c, nocmp, 1, ncmp1 )
            if (icmp1 .eq. 0) goto 20
!
            do ipt = 1, nbpt
!
                do isp = 1, nbsp
!
                    call cesexi('C', jce1d, jce1l, ima1, ipt,&
                                isp, icmp1, iad1)
                    if (iad1 .le. 0) goto 40
                    if (.not. zl(jce1l-1+iad1)) goto 40
                    call cesexi('C', jce2d, jce2l, ima2, ipt,&
                                isp, icmp2, iad2)
                    ASSERT(iad2.gt.0)
!
                    zl(jce2l-1+iad2) = .true.
!
                    if (tsca .eq. 'R') then
                        zr(jce2v-1+iad2) = zr(jce1v-1+iad1)
                    else if (tsca.eq.'C') then
                        zc(jce2v-1+iad2) = zc(jce1v-1+iad1)
                    else if (tsca.eq.'I') then
                        zi(jce2v-1+iad2) = zi(jce1v-1+iad1)
                    else if (tsca.eq.'L') then
                        zl(jce2v-1+iad2) = zl(jce1v-1+iad1)
                    else if (tsca.eq.'K8') then
                        zk8(jce2v-1+iad2) = zk8(jce1v-1+iad1)
                    else
                        ASSERT(.false.)
                    endif
!
 40                 continue
                end do
!
            end do
!
 20         continue
        end do
!
    end do
!
    call jedema()
end subroutine
