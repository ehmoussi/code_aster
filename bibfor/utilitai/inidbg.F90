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

subroutine inidbg()
    implicit none
!
!  BUT: INITIALISE LE COMMON CZDBG
!       POUR FILTRER L'IMPRESSION DES MESSAGES EN NIVEAU 2
!
!     COMMON /CZDBG/CZCONT,CZMECA,CZPILO
!
!     CZCONT='CONTACT' SI ON SOUHAITE IMPRIMER LES MESSAGES DU CONTACT
!     CZMECA='MECA_NON_LINE' POUR LES MESSAGES DEDIES A 'MECA_NON_LINE'
!     CZPILO='PILOTE' POUR LES MESSAGES DEDIES AU PILOTAGE
!     CZAPPA='APPARIEMENT' POUR LES MESSAGES DEDIES A L'APPARIEMENT
!     CZFACT='FACTOR' POUR LES MESSAGES DEDIES A LA FACTORISATION
!
!-----------------------------------------------------------------------
!
!
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: ifm, niv, n, i, jdbg
    character(len=16) :: czcont, czmeca, czpilo, czfact, czappa
    common /czdbg/czcont,czmeca,czpilo,czfact,czappa
!
    call jemarq()
!
    czcont=' '
    czmeca=' '
    czpilo=' '
    czfact=' '
    czappa=' '
!
    call infniv(ifm, niv)
    if (niv .ne. 2) goto 9999
!
    call getvtx(' ', 'INFO_DBG', nbval=0, nbret=n)
    if (n .ne. 0) then
!        -- ON IMPRIME UNIQUEMENT CE QUI EST DEMANDE --
        n=-n
        call wkvect('&&INIDBG', 'V V K16', n, jdbg)
        call getvtx(' ', 'INFO_DBG', nbval=n, vect=zk16(jdbg))
        do 10 i = 1, n
            if (zk16(jdbg+i-1)(1:7) .eq. 'CONTACT') then
                czcont='CONTACT'
                else if(zk16(jdbg+i-1).eq.'MECA_NON_LINE' .or. zk16(jdbg+&
            i-1).eq.'MECANONLINE')then
                czmeca='MECA_NON_LINE'
            else if (zk16(jdbg+i-1).eq.'PILOTAGE') then
                czpilo='PILOTAGE'
            else if (zk16(jdbg+i-1).eq.'APPARIEMENT') then
                czappa='APPARIEMENT'
            else if (zk16(jdbg+i-1).eq.'FACTORISATION') then
                czfact='FACTORISATION'
            endif
10      continue
    else
!        -- ON IMPRIME TOUT SANS RESTRICTION --
        czcont='CONTACT'
        czmeca='MECA_NON_LINE'
        czpilo='PILOTE'
        czfact='FACTORISATION'
        czappa='APPARIEMENT'
    endif
!
    call jedetr('&&INIDBG')
!
9999  continue
!
    call jedema()
!
end subroutine
