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

subroutine rc36zz(noma, nomgd, nbcmp, nocmp, nbma,&
                  listma, chelem)
    implicit   none
#include "jeveux.h"
#include "asterfort/cescre.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: nbcmp, nbma, listma(*)
    character(len=8) :: noma, nomgd
    character(len=16) :: nocmp(*)
    character(len=24) :: chelem
!     MISE A ZERO D'UN CHAM_ELEM DE TYPE ELNO
!
!     ------------------------------------------------------------------
!
    integer ::   jcesl, im, ima, nbpt, decal, iad, ipt, icmp, iret
    real(kind=8), pointer :: cesv(:) => null()
    integer, pointer :: cesd(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
    call jeexin(chelem(1:19)//'.CESD', iret)
!
    if (iret .eq. 0) then
        call cescre('V', chelem, 'ELNO', noma, nomgd,&
                    nbcmp, nocmp, [-1], [-1], [-nbcmp])
    endif
!
    call jeveuo(chelem(1:19)//'.CESD', 'L', vi=cesd)
    call jeveuo(chelem(1:19)//'.CESV', 'E', vr=cesv)
    call jeveuo(chelem(1:19)//'.CESL', 'E', jcesl)
!
    do 20 im = 1, nbma
        ima = listma(im)
        nbpt = cesd(5+4*(ima-1)+1)
        decal = cesd(5+4*(ima-1)+4)
        do 22 ipt = 1, nbpt
            do 24 icmp = 1, nbcmp
                iad = decal + (ipt-1)*nbcmp + icmp
                zl(jcesl-1+iad) = .true.
                cesv(iad) = 0.d0
24          continue
22      continue
20  end do
!
    call jedema()
!
end subroutine
