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
!
subroutine op0094()
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
! Command DEFI_TRC
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbhist, nbtrc, nbparr, ibid, lonmax, nbval, i, j, jvale, nbv, ind
    parameter    ( nbparr = 19 )
    real(kind=8) ::  xnbv, vale(6)
    character(len=8) :: k8b, nomtrc, typarr(nbparr)
    character(len=16) :: concep, nomcmd, noparr(nbparr)
    complex(kind=8) :: c16b
!
    data noparr / 'VITESSE' , 'PARA_EQ' , 'COEF_0' , 'COEF_1' ,&
     &              'COEF_2' , 'COEF_3' , 'COEF_4' , 'COEF_5' ,&
     &              'NB_POINT' ,&
     &              'Z1' , 'Z2' , 'Z3' , 'TEMP' ,&
     &              'SEUIL' , 'AKM' , 'BKM' , 'TPLM',&
     &              'DREF', 'A' /
    data typarr / 'R' , 'R' , 'R' , 'R' , 'R' , 'R' , 'R' , 'R' , 'R',&
     &              'R' , 'R' , 'R' , 'R' ,&
     &              'R' , 'R' , 'R' , 'R',&
     &              'R' , 'R' /
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    c16b=(0.d0,0.d0)
    call infmaj()
!
    call getres(nomtrc, concep, nomcmd)
!
    call getfac('HIST_EXP', nbhist)
    call getfac('TEMP_MS', nbtrc)
    ASSERT(nbtrc .eq. 1)
!
!
    call tbcrsd(nomtrc, 'G')
    call tbajpa(nomtrc, nbparr, noparr, typarr)
!
    lonmax = 0
    do i = 1, nbhist
        call getvr8('HIST_EXP', 'VALE', iocc=i, nbval=0, nbret=nbval)
        lonmax = max ( lonmax , -nbval )
    end do
    call wkvect('&&OP0094.VALE', 'V V R', lonmax, jvale)
!
    do i = 1, nbhist
        call getvr8('HIST_EXP', 'VALE', iocc=i, nbval=0, nbret=nbval)
        nbval = -nbval
        call getvr8('HIST_EXP', 'VALE', iocc=i, nbval=nbval, vect=zr(jvale))
        call tbajli(nomtrc, 8, noparr, [ibid], zr(jvale),&
                    [c16b], k8b, 0)
        xnbv = dble(( nbval - 8 ) / 4 )
        call tbajli(nomtrc, 1, noparr(9), [ibid], [xnbv],&
                    [c16b], k8b, i)
    end do
!
    do i = 1, nbhist
        call getvr8('HIST_EXP', 'VALE', iocc=i, nbval=0, nbret=nbval)
        nbval = -nbval
        call getvr8('HIST_EXP', 'VALE', iocc=i, nbval=nbval, vect=zr(jvale))
        nbv = ( nbval - 8 ) / 4
        do j = 1, nbv
            ind = jvale + 8 + 4*(j-1)
            call tbajli(nomtrc, 4, noparr(10), [ibid], zr(ind),&
                        [c16b], k8b, 0)
        end do
    end do
!
    i = 1
    call getvr8('TEMP_MS', 'SEUIL', iocc=i, scal=vale(1), nbret=ibid)
    call getvr8('TEMP_MS', 'AKM', iocc=i, scal=vale(2), nbret=ibid)
    call getvr8('TEMP_MS', 'BKM', iocc=i, scal=vale(3), nbret=ibid)
    call getvr8('TEMP_MS', 'TPLM', iocc=i, scal=vale(4), nbret=ibid)
    call getvr8('GRAIN_AUST', 'DREF', iocc=i, scal=vale(5), nbret=ibid)
    if (ibid .eq. 0) vale(5) = 0.d0
    call getvr8('GRAIN_AUST', 'A', iocc=i, scal=vale(6), nbret=ibid)
    if (ibid .eq. 0) vale(6) = 0.d0
    call tbajli(nomtrc, 6, noparr(14), [ibid], vale,&
                [c16b], k8b, 0)
!
    call jedema()
end subroutine
