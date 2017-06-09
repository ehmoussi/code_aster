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

subroutine prnchk(nbsn, adress, global, fils, frere,&
                  lgsn, lfront, invsup, seq)
! aslint: disable=W1304
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    integer(kind=4) :: global(*)
    integer :: adress(*), fils(*), frere(*), lgsn(*), lfront(*)
    integer :: invsup(*), seq(*), nbsn
    integer :: sni, sn, sn0, vois, m, vali(2), i
    aster_logical :: trouv
    do i = 1, nbsn
        sni=seq(i)
        m = lfront(sni)
!
        if (m .gt. 0) then
            vois=global(adress(sni)+lgsn(sni))
            sn0=invsup(vois)
            trouv=.false.
            sn = fils(sn0)
!
  2         continue
            if (sn .ne. 0) then
                if (sn .eq. sni) trouv=.true.
                sn=frere(sn)
                goto 2
            endif
!
            if (.not.trouv) then
                vali(1)=sni
                vali(2)=sn0
                call utmess('F', 'ALGELINE5_59', ni=2, vali=vali)
            endif
        endif
    end do
end subroutine
