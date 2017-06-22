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

subroutine rbph01(trange, nbcham, typea, itresu, nfonct,&
                  basemo, typref, typbas, tousno, multap)
    implicit none
#include "asterf_types.h"
#include "asterfort/getvtx.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
    integer :: nbcham, itresu(*), nfonct
    character(len=8) :: basemo
    character(len=16) :: typea(*), typbas(*)
    character(len=19) :: trange, typref(*)
    aster_logical :: tousno, multap
!     OPERATEUR REST_BASE_PHYS
!               TRAITEMENT DES MOTS CLES "TOUT_CHAM" ET "NOM_CHAM"
!     ------------------------------------------------------------------
    integer :: n1, i, iret
    character(len=8) :: blanc, mode
    character(len=16) :: champ(8)
    character(len=19) :: nomcha
!     ------------------------------------------------------------------
    data blanc    /'        '/
!     ------------------------------------------------------------------
!
    mode = basemo
!
    champ(1)=' '
    call getvtx(' ', 'TOUT_CHAM', scal=champ(1), nbret=n1)
!
    if (champ(1) .eq. 'OUI') then
        nbcham = 3
        typea(1) = 'DEPL            '
        typea(2) = 'VITE            '
        typea(3) = 'ACCE            '
        call jeexin(trange//'.DEPL', iret)
        if (iret .eq. 0) then
            call utmess('F', 'ALGORITH10_11')
        else
            call jeveuo(trange//'.DEPL', 'L', itresu(1))
!
        endif
!
        call jeexin(trange//'.VITE', iret)
        if (iret .eq. 0) then
            call utmess('F', 'ALGORITH10_12')
        else
            call jeveuo(trange//'.VITE', 'L', itresu(2))
        endif
        call jeexin(trange//'.ACCE', iret)
        if (iret .eq. 0) then
            call utmess('F', 'ALGORITH10_13')
        else
            call jeveuo(trange//'.ACCE', 'L', itresu(3))
        endif
        if (nfonct .ne. 0) then
            nbcham = 4
            typea(4) = 'ACCE_ABSOLU     '
            itresu(4) = itresu(3)
        endif
        if (mode .eq. blanc) then
            typref(1) = ' '
            typref(2) = ' '
            typref(3) = ' '
            typref(4) = ' '
        else
            call rsexch(' ', basemo, 'DEPL', 1, nomcha,&
                        iret)
            typref(1) = nomcha
            typref(2) = nomcha
            typref(3) = nomcha
            typref(4) = nomcha
        endif
        typbas(1) = 'DEPL'
        typbas(2) = 'DEPL'
        typbas(3) = 'DEPL'
        typbas(4) = 'DEPL'
!
    else
!
        call getvtx(' ', 'NOM_CHAM', nbval=0, nbret=n1)
        nbcham = -n1
        call getvtx(' ', 'NOM_CHAM', nbval=nbcham, vect=champ, nbret=n1)
!
        do 10 i = 1, nbcham
            if (champ(i) .eq. 'DEPL') then
                typea(i) = 'DEPL'
                call jeexin(trange//'.DEPL', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_11')
                else
                    call jeveuo(trange//'.DEPL', 'L', itresu(i))
                endif
                if (mode .eq. blanc) then
                    typref(i) = ' '
                else
                    call rsexch(' ', basemo, typea(i), 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = 'DEPL'
!
            else if (champ(i) .eq. 'VITE') then
                typea(i) = 'VITE'
                call jeexin(trange//'.VITE', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_12')
                else
                    call jeveuo(trange//'.VITE', 'L', itresu(i))
                endif
                if (mode .eq. blanc) then
                    typref(i) = ' '
                else
                    call rsexch(' ', basemo, 'DEPL', 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = 'DEPL'
!
            else if (champ(i) .eq. 'ACCE') then
                typea(i) = 'ACCE'
                call jeexin(trange//'.ACCE', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_13')
                else
                    call jeveuo(trange//'.ACCE', 'L', itresu(i))
                endif
                if (mode .eq. blanc) then
                    typref(i) = ' '
                else
                    call rsexch(' ', basemo, 'DEPL', 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = 'DEPL'
!
            else if (champ(i) .eq. 'ACCE_ABSOLU') then
                typea(i) = 'ACCE_ABSOLU'
                call jeexin(trange//'.ACCE', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_13')
                else
                    call jeveuo(trange//'.ACCE', 'L', itresu(i))
                endif
                if (mode .eq. blanc) then
                    typref(i) = ' '
                else
                    call rsexch(' ', basemo, 'DEPL', 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = 'DEPL'
!
                elseif ( champ(i) .eq. 'FORC_NODA' .or. champ(i) .eq.&
            'REAC_NODA' ) then
                typea(i) = champ(i)
                call jeexin(trange//'.DEPL', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_11')
                else
                    call jeveuo(trange//'.DEPL', 'L', itresu(i))
                endif
                if (multap) then
                    call utmess('F', 'ALGORITH10_14')
                endif
                if (mode .eq. blanc) then
                    call utmess('F', 'ALGORITH10_15')
                else
                    call rsexch('F', basemo, typea(i), 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = typea(i)
!
            else
                typea(i) = champ(i)
                call jeexin(trange//'.DEPL', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'ALGORITH10_11')
                else
                    call jeveuo(trange//'.DEPL', 'L', itresu(i))
                endif
                if (.not. tousno) then
                    call utmess('F', 'ALGORITH10_17', sk=typea(i))
                endif
                if (multap) then
                    call utmess('F', 'ALGORITH10_14')
                endif
                if (mode .eq. blanc) then
                    call utmess('F', 'ALGORITH10_15')
                else
                    call rsexch('F', basemo, typea(i), 1, nomcha,&
                                iret)
                    typref(i) = nomcha
                endif
                typbas(i) = typea(i)
!
            endif
 10     continue
    endif
!
end subroutine
