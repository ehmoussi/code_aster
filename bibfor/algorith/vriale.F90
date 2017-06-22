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

subroutine vriale()
    implicit none
!
!  BUT: VERIFICATIONS SYNTAXIQUES POUR
!        LE CALCUL DYNAMIQUE ALEATOIRE
!
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
    integer :: ibid, nbamor, nbmode, nindex, nbindi, nbindj, nbcmpi, nbcmpj
    integer :: nnoeex, nvasex, ncmpex, nmost1, napexc
    real(kind=8) :: fremin, fremax
    character(len=4) :: excmod
    character(len=8) :: intrep
    character(len=16) :: tyconc, nomcmd, graexc
!     ------------------------------------------------------------------
!
    call getres(intrep, tyconc, nomcmd)
!
!---NB MODES=NB AMORTISSEMENTS
!
    call getvr8('BASE_MODALE', 'AMOR_REDUIT', iocc=1, nbval=0, nbret=nbamor)
    call getvis('BASE_MODALE', 'NUME_ORDRE', iocc=1, nbval=0, nbret=nbmode)
    nbamor = -nbamor
    nbmode = -nbmode
    if (nbamor .ne. 0 .and. nbamor .ne. nbmode) then
        call utmess('E', 'ALGORITH11_29')
    endif
!
    call getvtx('EXCIT', 'MODAL', iocc=1, scal=excmod, nbret=ibid)
    call getvis('EXCIT', 'NUME_ORDRE_I', iocc=1, nbval=0, nbret=nindex)
    call getvtx('EXCIT', 'GRANDEUR', iocc=1, scal=graexc, nbret=ibid)
    call getvis('EXCIT', 'NUME_ORDRE_I', iocc=1, nbval=0, nbret=nbindi)
    call getvis('EXCIT', 'NUME_ORDRE_J', iocc=1, nbval=0, nbret=nbindj)
!
!--- COHERENCE ENTRE LES MODES ET L'INTERSPECTRE DE LA FONCTION
!                                  ACCEPTANCE
!
    nindex = -nindex
    if (excmod .eq. 'OUI' .and. nbmode .ne. nindex) then
        call utmess('A', 'ALGORITH11_30')
    endif
!
!---NNOEEX=NINDEX OU NNOEEX=2*NINDEX
!
    if (nbindi .eq. 0) then
        call getvtx('EXCIT', 'NOEUD_I', iocc=1, nbval=0, nbret=nbindi)
        call getvtx('EXCIT', 'NOEUD_J', iocc=1, nbval=0, nbret=nbindj)
        call getvtx('EXCIT', 'NOM_CMP_I', iocc=1, nbval=0, nbret=nbcmpi)
        call getvtx('EXCIT', 'NOM_CMP_J', iocc=1, nbval=0, nbret=nbcmpj)
        if (nbcmpi .ne. nbcmpj) then
            call utmess('E', 'PREPOST3_84')
        endif
        if (nbcmpi .ne. nbindi) then
            call utmess('E', 'PREPOST3_85')
        endif
    endif
    if (nbindj .ne. nbindi) then
        call utmess('E', 'ALGORITH11_31')
    endif
    nindex = -nbindi
!
    call getvtx('EXCIT', 'NOEUD', iocc=1, nbval=0, nbret=nnoeex)
    nnoeex = -nnoeex
    if (nnoeex .ne. 0) then
        napexc = nnoeex
    else
        napexc=0
    endif
!
    call getvid('EXCIT', 'CHAM_NO', iocc=1, nbval=0, nbret=nvasex)
    nvasex = -nvasex
    if (nvasex .ne. 0) then
        napexc = nvasex
        graexc = 'EFFO'
    endif
!
    if ((graexc.eq.'SOUR_PRESS') .or. (graexc.eq.'SOUR_FORCE')) then
        if (nnoeex .ne. 2*nindex) then
            call utmess('E', 'ALGORITH11_32')
        endif
    else if ((napexc.ne.nindex).and.(excmod.eq.'NON')) then
        call utmess('E', 'ALGORITH11_33')
    endif
!
!------NNOEEX=NCMPEX
!
    call getvtx('EXCIT', 'NOM_CMP', iocc=1, nbval=0, nbret=ncmpex)
    ncmpex = -ncmpex
    if (nnoeex .ne. ncmpex) then
        call utmess('E', 'ALGORITH11_34')
    endif
!
!---PRESENCE DE MODE STATIQUE QUAND ON EST EN DEPL IMPOSE
!
    call getvid(' ', 'MODE_STAT', nbval=0, nbret=nmost1)
    if ((graexc.eq.'DEPL_R') .and. (nmost1.eq.0) .and. (nvasex.eq.0)) then
        call utmess('E', 'ALGORITH11_35')
    else if ((graexc.ne.'DEPL_R').and.(nmost1.ne.0)) then
        call utmess('E', 'ALGORITH11_36')
    endif
!
!---FREMIN < FREMAX
!
    call getvr8('REPONSE', 'FREQ_MIN', iocc=1, nbval=0, nbret=ibid)
    if (ibid .ne. 0) then
        call getvr8('REPONSE', 'FREQ_MIN', iocc=1, scal=fremin, nbret=ibid)
    endif
    call getvr8('REPONSE', 'FREQ_MAX', iocc=1, nbval=0, nbret=ibid)
    if (ibid .ne. 0) then
        call getvr8('REPONSE', 'FREQ_MAX', iocc=1, scal=fremax, nbret=ibid)
        if (fremin .ge. fremax) then
            call utmess('E', 'ALGORITH11_37')
        endif
    endif
!
end subroutine
