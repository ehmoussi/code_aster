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

subroutine op0063()
!
!        RECUPERATION RESULTATS DE MODE_NON_LINE
!-----------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterc/r8vide.h"
#include "asterfort/tbliva.h"
#include "asterfort/transft.h"
#include "asterfort/vprecu.h"
    integer :: iordr, ival(1), ibid, iret, neq
    integer :: nbpara, nbtrou, nbmode, npari, nparr, npark, lvect
    integer ::  nblig
    integer :: inbpt
    character(len=4) :: nomsym(1)
    character(len=8) :: k8b, modein, nomres, modenl, kvide
    character(len=16) :: lipar(1), typres, nomcmd, k16bid, tres
    character(len=19) :: typmod
    character(len=24) :: k24bid, kvec
    real(kind=8) :: rvide
    real(kind=8) :: r8b
    complex(kind=8) :: c16b, cvide
    integer, pointer :: tbnp(:) => null()
!
    call jemarq()
    call getres(nomres, typres, nomcmd)
!
    kvide = '????????'
    rvide = r8vide()
    cvide = dcmplx(rvide,rvide)
!
    call getvid(' ', 'MODE_NON_LINE', scal=modenl)
!
    call jeveuo(modenl//'           .TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblig = tbnp(2)
!
    call getvis(' ', 'NUME_ORDRE', scal=iordr)
!
    ival(1) = iordr
    lipar(1) = 'NUME_ORDRE'
!
    call tbliva(modenl, 1, lipar, ival, [r8b],&
                [c16b], k8b, k8b, [r8b], 'NOM_SD',&
                k8b, ibid, r8b, c16b, modein,&
                iret)
!
    call getvtx(' ', 'TYPE_RESU', scal=tres)
!
    if (tres .eq. 'MODE_MECA') then
        call copisd('RESULTAT', 'G', modein, nomres)
    else
        call getvis(' ', 'NB_INST', scal=inbpt)
        kvec = '&&_COEFF_FOURIER'
        nomsym(1) = 'DEPL'
        nbpara = 0
        nbtrou = -1
        call vprecu(modein, nomsym(1), nbtrou, [ibid], kvec,&
                    nbpara, k16bid, k24bid, k24bid, k24bid,&
                    neq, nbmode, typmod, npari, nparr,&
                    npark)
        call jeveuo(kvec, 'L', lvect)
        call transft(modein, kvec, neq, inbpt, nomres)
        call jedetr(kvec)
    endif
!
    call jedema()
!
end subroutine
