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

subroutine x195cb(tychr, nomgd, chou)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/idensd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerazo.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: jacques.pellet at edf.fr
!     BUT : TRAITER :
!          - OPTION 'COMB' DE LA COMMANDE CREA_CHAMP
!     -----------------------------------------------------------------
!
!

    character(len=8) :: chou
    character(len=4) :: tychr, tych1
    integer :: ib, nbocc, iocc, k, jvale1, jvale2, n1, n2
    real(kind=8) :: coefr
    character(len=8) :: nomgd, nomgd1, ma1, ma2
    character(len=3) :: tsca
    character(len=19) :: ch1, ch2, pfcn1, pfcn2
!
!     -----------------------------------------------------------------
!
    call jemarq()
    call getfac('COMB', nbocc)
    ASSERT(nbocc.ge.1)
    ASSERT(tychr.eq.'NOEU')
!
!
!     -- 1. CREATION DU CHAMP "OUT" SUR LE MODELE DU 1ER CHAMP "IN"
!     -------------------------------------------------------------
!     -- ATTENTION : LA COMMANDE PEUT ETRE REENTRANTE,
!        IL NE FAUT PAS DETRUIRE CHOU TOUT DE SUITE.
    call getvid('COMB', 'CHAM_GD', iocc=1, scal=ch1, nbret=ib)
    ch2='&&X195CB.CHOU'
    call copisd('CHAMP', 'V', ch1, ch2)
!     -- INITIALISATION A ZERO :
    call jeveuo(ch2//'.VALE', 'E', jvale2)
    call jelira(ch2//'.VALE', 'LONMAX', n1)
    call jerazo(ch2//'.VALE', n1, 1)
    call dismoi('NOM_MAILLA', ch2, 'CHAMP', repk=ma2)
    call dismoi('PROF_CHNO', ch2, 'CHAM_NO', repk=pfcn2)
!
!
!     -- 2. CALCUL DU CONTENU DE CH2 :
!     ---------------------------------
    do iocc = 1, nbocc
        call getvid('COMB', 'CHAM_GD', iocc=iocc, scal=ch1, nbret=ib)
!
!       -- QUELQUES VERIFICATIONS DE COHERENCE :
        call dismoi('TYPE_CHAMP', ch1, 'CHAMP', repk=tych1)
        if (tych1 .ne. 'NOEU') then
            call utmess('F', 'CREACHAMP1_10')
        endif
!
        call dismoi('NOM_MAILLA', ch1, 'CHAMP', repk=ma1)
        if (ma1 .ne. ma2) then
            call utmess('F', 'CREACHAMP1_13')
        endif
!
        call dismoi('PROF_CHNO', ch1, 'CHAM_NO', repk=pfcn1)
        if (.not.idensd('PROF_CHNO',pfcn1,pfcn2)) then
            call utmess('F', 'CREACHAMP1_12')
        endif
!
        call jelira(ch1//'.VALE', 'LONMAX', n2)
        if (n2 .ne. n1) then
            ASSERT(.false.)
        endif
!
        call dismoi('NOM_GD', ch1, 'CHAMP', repk=nomgd1)
        if (nomgd1 .ne. nomgd) then
            call utmess('F', 'CREACHAMP1_11')
        endif
!
        call dismoi('TYPE_SCA', nomgd1, 'GRANDEUR', repk=tsca)
        ASSERT(tsca.eq.'R'.or.tsca.eq.'C')
!
!       -- CUMUL DES VALEURS :
        call jeveuo(ch1//'.VALE', 'L', jvale1)
        call getvr8('COMB', 'COEF_R', iocc=iocc, scal=coefr, nbret=ib)
        ASSERT(ib.eq.1)
        if (tsca .eq. 'R') then
            do k = 1, n1
                zr(jvale2-1+k)=zr(jvale2-1+k)+coefr*zr(jvale1-1+k)
            end do
        else if (tsca.eq.'C') then
            do k = 1, n1
                zc(jvale2-1+k)=zc(jvale2-1+k)+coefr*zc(jvale1-1+k)
            end do
        endif
    end do
!
!
!     -- RECOPIE DE CH2 DANS CHOU :
!     -------------------------------
    call copisd('CHAMP', 'G', ch2, chou)
    call detrsd('CHAMP', ch2)
!
    call jedema()
end subroutine
