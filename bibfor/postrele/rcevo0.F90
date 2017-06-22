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

subroutine rcevo0(intitu, nbinti, lsn, lfatig, nbtran)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcver1.h"
#include "asterfort/rcveri.h"
#include "asterfort/tbexip.h"
#include "asterfort/tbexv1.h"
#include "asterfort/wkvect.h"
    integer :: nbinti, nbtran
    aster_logical :: lsn, lfatig
    character(len=24) :: intitu
!     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
!     DETERMINE LE NOMBRE DE SEGMENT A POST-TRAITER
!
!     ------------------------------------------------------------------
    integer :: n1, jinti, nbint0, i, j, jint0, iocc, n2, n3
    aster_logical :: exist
    character(len=8) :: typ, table, tabfl0, tabpr0
    character(len=16) :: motclf
    character(len=24) :: intit0
! DEB ------------------------------------------------------------------
    call jemarq()
!
    nbinti = 0
    motclf = 'TRANSITOIRE'
    call getfac(motclf, nbtran)
    if (nbtran .eq. 0) goto 9999
!
    do 100 iocc = 1, nbtran
!
        call getvid(motclf, 'TABL_RESU_MECA', iocc=iocc, scal=table, nbret=n1)
        call getvid(motclf, 'TABL_SIGM_THER', iocc=iocc, scal=tabfl0, nbret=n2)
        call getvid(motclf, 'TABL_RESU_PRES', iocc=iocc, scal=tabpr0, nbret=n3)
!
!       VERIFICATION DE L'ORDRE DES NOEUDS DANS LES TABLES
        call rcveri(table)
        if (n2 .ne. 0) call rcver1('MECANIQUE', table, tabfl0)
        if (n3 .ne. 0) call rcver1('MECANIQUE', table, tabpr0)
!
        if (iocc .eq. 1) then
            call tbexip(table, 'INTITULE', exist, typ)
            if (exist) then
                ASSERT(typ(1:3).eq.'K16')
                call tbexv1(table, 'INTITULE', intitu, 'V', nbinti,&
                            typ)
            else
                call wkvect(intitu, 'V V K16', 1, jinti)
                zk16(jinti) = ' '
            endif
        endif
!
100 end do
!
    if (lsn .and. .not.lfatig .and. nbtran .gt. 1) then
        nbint0 = nbtran * nbinti
        intit0 = '&&RCEVO0.INTITULE'
        call jeveuo(intitu, 'L', jinti)
        call wkvect(intit0, 'V V K16', 1, jint0)
        do 10 i = 1, nbinti
            zk16(jint0+i-1) = zk16(jinti+i-1)
 10     continue
        call jedetr(intitu)
        call wkvect(intitu, 'V V K16', nbint0, jinti)
        do 20 i = 1, nbinti
            do 22 j = 1, nbtran
                zk16(jinti-1+nbtran*(i-1)+j) = zk16(jint0+i-1)
 22         continue
 20     continue
        call jedetr(intit0)
    else
        nbtran = 1
    endif
!
9999 continue
    call jedema()
end subroutine
