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

subroutine tbutnu(motfac, iocc, nomjv, nbinst, nomtab,&
                  prec, crit)
    implicit none
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsindi.h"
#include "asterfort/tbexv1.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: iocc, nbinst
    real(kind=8) :: prec
    character(len=8) :: crit
    character(len=16) :: motfac
    character(len=*) :: nomjv, nomtab
!
!     RECUPERER LES INSTANTS DANS UNE TABLE A PARTIR
!        DU MOT CLE  INST
!        DU MOT CLE  LIST_INST
!        PAR DEFAUT, TOUT_INST
!
!
    integer :: ibid, np, nc, n1, n2, jinstd, jinst, jordr, ii, nbval, nbtrou
    integer :: nutrou(1)
    real(kind=8) :: dinst
    real(kind=8) :: valr
    complex(kind=8) :: cbid
    character(len=8) :: k8b
    character(len=24) :: valk
    character(len=19) :: listr
! DEB ------------------------------------------------------------------
!
    call jemarq()
!
    call getvr8(motfac, 'PRECISION', iocc=iocc, scal=prec, nbret=np)
    call getvtx(motfac, 'CRITERE', iocc=iocc, scal=crit, nbret=nc)
!
    nbinst = 0
    call getvid(motfac, 'LIST_INST', iocc=iocc, scal=listr, nbret=n1)
    if (n1 .ne. 0) then
        call jeveuo(listr//'.VALE', 'L', jinstd)
        call jelira(listr//'.VALE', 'LONMAX', nbinst)
        call wkvect(nomjv, 'V V R', nbinst, jinst)
        call wkvect('&&TBUTNU.ORDRE', 'V V I', nbinst, jordr)
        do 10 ii = 1, nbinst
            zr(jinst+ii-1) = zr(jinstd+ii-1)
            zi(jordr+ii-1) = ii
10      continue
    endif
!
    call getvr8(motfac, 'INST', iocc=iocc, nbval=0, nbret=n2)
    if (n2 .ne. 0) then
        nbinst = -n2
        call wkvect(nomjv, 'V V R', nbinst, jinst)
        call getvr8(motfac, 'INST', iocc=iocc, nbval=nbinst, vect=zr(jinst),&
                    nbret=n2)
        call wkvect('&&TBUTNU.ORDRE', 'V V I', nbinst, jordr)
        do 12 ii = 1, nbinst
            zi(jordr+ii-1) = ii
12      continue
    endif
!
    call tbexv1(nomtab, 'INST', '&&TBUTNU.INST_D', 'V', nbval,&
                k8b)
    call jeveuo('&&TBUTNU.INST_D', 'L', jinstd)
    do 20 ii = 1, nbinst
        dinst = zr(jinst+ii-1)
        call rsindi('R8  ', jinstd, 1, jordr, ibid,&
                    dinst, k8b, cbid, prec, crit,&
                    nbval, nbtrou, nutrou, 1)
        if (nbtrou .lt. 1) then
            valr = dinst
            valk = nomtab
            call utmess('F', 'PREPOST5_74', sk=valk, sr=valr)
        else if (nbtrou.gt.1) then
            valr = dinst
            valk = nomtab
            call utmess('F', 'PREPOST5_75', sk=valk, sr=valr)
        endif
20  end do
!
    if (nbinst .eq. 0) then
        prec = 1.d-06
        crit = 'RELATIF'
        nbinst = nbval
        call wkvect(nomjv, 'V V R', nbinst, jinst)
        do 30 ii = 1, nbinst
            zr(jinst+ii-1) = zr(jinstd+ii-1)
30      continue
    else
        call jedetr('&&TBUTNU.ORDRE')
    endif
    call jedetr('&&TBUTNU.INST_D')
!
    call jedema()
end subroutine
