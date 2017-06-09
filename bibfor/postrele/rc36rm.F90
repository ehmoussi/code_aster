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

subroutine rc36rm()
    implicit none
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!     RECUPERATION DES DONNEES DE "RESU_MECA"
!
! IN  : NBMA   : NOMBRE DE MAILLES D'ANALYSE
! IN  : LISTMA : LISTE DES MAILLES D'ANALYSE
!     ------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/celces.h"
#include "asterfort/codent.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsutnu.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: n1, iocc, iret, jord, jnume, nbordr, jcham, nbresu
    real(kind=8) :: prec
    integer :: vali(2)
    character(len=8) :: k8b, resu, crit
    character(len=16) :: motclf, nomsym
    character(len=24) :: knum, nomcha, chams0
    character(len=24) :: valk(7)
! DEB ------------------------------------------------------------------
    call jemarq()
!
    motclf = 'RESU_MECA'
    knum = '&&RC3600.NUME_ORDRE'
!
    call getfac(motclf, nbresu)
!
    call wkvect('&&RC3600.NUME_CHAR', 'V V I  ', nbresu, jnume)
    call wkvect('&&RC3600.CHAMP', 'V V K24', nbresu, jcham)
!
    do 10, iocc = 1, nbresu, 1
!
    call getvis(motclf, 'NUME_CHAR', iocc=iocc, scal=zi(jnume+iocc-1), nbret=n1)
!
!
    call getvid(motclf, 'RESULTAT', iocc=iocc, scal=resu, nbret=n1)
    if (n1 .ne. 0) then
        call getvtx(motclf, 'NOM_CHAM', iocc=iocc, scal=nomsym, nbret=n1)
        call getvr8(motclf, 'PRECISION', iocc=iocc, scal=prec, nbret=n1)
        call getvtx(motclf, 'CRITERE', iocc=iocc, scal=crit, nbret=n1)
        call rsutnu(resu, motclf, iocc, knum, nbordr,&
                    prec, crit, iret)
        if (iret .ne. 0) then
            vali (1) = iocc
            valk (1) = nomsym
            valk (2) = resu
            call utmess('F', 'POSTRCCM_20', nk=2, valk=valk, si=vali(1))
        endif
        if (nbordr .ne. 1) then
            vali (1) = iocc
            valk (1) = nomsym
            valk (2) = resu
            call utmess('F', 'POSTRCCM_21', nk=2, valk=valk, si=vali(1))
        endif
        call jeveuo(knum, 'L', jord)
        call rsexch('F', resu, nomsym, zi(jord), nomcha,&
                    iret)
        call jedetr(knum)
!
    else
        call getvid(motclf, 'CHAM_GD', iocc=iocc, scal=nomcha, nbret=n1)
!
    endif
!
    call codent(iocc, 'D0', k8b)
    chams0 = '&&RC3602.'//k8b
    call celces(nomcha, 'V', chams0)
    zk24(jcham+iocc-1) = chams0
!
    10 end do
!
    call jedema()
end subroutine
