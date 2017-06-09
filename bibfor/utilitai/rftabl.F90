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

subroutine rftabl(tabres)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/foattr.h"
#include "asterfort/foimpr.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ordonn.h"
#include "asterfort/tbexfo.h"
#include "asterfort/tbimfi.h"
#include "asterfort/tbliva.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
    character(len=*) :: tabres
!
!     OPERATEUR "RECU_FONCTION"   MOT CLE "TABLE"
!     ------------------------------------------------------------------
    integer :: ibid, n2, n3, n4, nparfi, iret
    integer :: ifm, niv
    real(kind=8) :: r8b
    complex(kind=8) :: c16b
    character(len=8) :: k8b, interp, prolgd
    character(len=16) :: nomcmd, typcon, parax, paray
    character(len=19) :: nomfon, newtab, newta1
    character(len=24) :: nopara, nomf
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
!
    call getres(nomfon, typcon, nomcmd)
!
    call getvtx(' ', 'PARA_X', scal=parax, nbret=n2)
    call getvtx(' ', 'PARA_Y', scal=paray, nbret=n3)
    call getvtx(' ', 'NOM_PARA_TABL', scal=nopara, nbret=n4)
!
    interp = 'NON NON '
    prolgd = 'EE      '
!
    newtab = tabres
!
!     ------------------------------------------------------------------
!
!                 --- TRAITEMENT DU MOT CLE "FILTRE" ---
!
!     ------------------------------------------------------------------
    call getfac('FILTRE', nparfi)
    if (nparfi .ne. 0) then
        newta1 = '&&OP0177.FILTRE '
        call tbimfi(nparfi, newtab, newta1, iret)
        if (iret .ne. 0) then
            call utmess('F', 'UTILITAI7_11')
        endif
        newtab = newta1
    endif
!     ------------------------------------------------------------------
!
    if (n2+n3 .ne. 0) then
!
        call tbexfo(newtab, parax, paray, nomfon, interp,&
                    prolgd, 'G')
!
    else if (n4 .ne. 0) then
!
        call tbliva(newtab, 0, k8b, [ibid], [r8b],&
                    [c16b], k8b, k8b, [r8b], nopara,&
                    k8b, ibid, r8b, c16b, nomf,&
                    iret)
        if (iret .ne. 0) then
            valk(1) = nopara
            valk(2)(1:19) = newtab
            call utmess('F', 'MODELISA2_91', nk=2, valk=valk)
        endif
        call copisd('FONCTION', 'G', nomf, nomfon)
!
    else
        call utmess('F', 'UTILITAI4_27')
    endif
!
!
    if (nparfi .ne. 0) call detrsd('TABLE', newta1)
!
    call foattr(' ', 1, nomfon)
!
!     --- VERIFICATION QU'ON A BIEN CREER UNE FONCTION ---
!         ET REMISE DES ABSCISSES EN ORDRE CROISSANT
    call ordonn(nomfon, 0)
!
    call titre()
    if (niv .gt. 1) call foimpr(nomfon, niv, ifm, 0, k8b)
!
    call jedema()
end subroutine
