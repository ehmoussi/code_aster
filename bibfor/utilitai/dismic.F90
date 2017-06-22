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

subroutine dismic(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(INCONNU)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsdocu.h"
    integer :: repi, ierd
    character(len=19) :: nomob
    character(len=*) :: questi
    character(len=32) :: repk
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE "INCONNU"(K19)
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=4) :: docu
!
!
!-----------------------------------------------------------------------
    integer ::  ire1, ire2, ire3, ire4, ire5, ire6
    integer :: ire7, iret
    character(len=24), pointer :: prol(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
!
    if (questi(1:8) .eq. 'RESULTAT') then
        call jeexin(nomob//'.NOVA', ire3)
        call jeexin(nomob//'.DESC', ire4)
        call jeexin(nomob//'.ORDR', ire5)
        call jeexin(nomob//'.TAVA', ire6)
        call jeexin(nomob//'.TACH', ire7)
        if (ire3 .gt. 0 .and. ire4 .gt. 0 .and. ire5 .gt. 0 .and. ire6 .gt. 0 .and. ire7&
            .gt. 0) then
            repk = 'OUI'
            goto 9999
        endif
!
    else if (questi(1:5) .eq. 'TABLE') then
        call jeexin(nomob//'.TBBA', ire3)
        call jeexin(nomob//'.TBNP', ire4)
        call jeexin(nomob//'.TBLP', ire5)
        if (ire3 .gt. 0 .and. ire4 .gt. 0 .and. ire5 .gt. 0) then
            repk = 'OUI'
            goto 9999
        endif
!
    else if (questi(1:7) .eq. 'CHAM_NO') then
        call jeexin(nomob//'.DESC', iret)
        if (iret .gt. 0) then
            call jelira(nomob//'.DESC', 'DOCU', cval=docu)
            if (docu .eq. 'CHNO') then
                repk = 'OUI'
                goto 9999
            endif
        endif
!
    else if (questi(1:9) .eq. 'CHAM_ELEM') then
        call jeexin(nomob//'.CELD', iret)
        if (iret .gt. 0) then
            repk = 'OUI'
            goto 9999
        endif
!
    else if (questi(1:4).eq.'TYPE') then
        call jeexin(nomob//'.TYPE', ire1)
        call jeexin(nomob//'.NOPA', ire2)
        call jeexin(nomob//'.NOVA', ire3)
        if (ire1 .gt. 0 .and. ire2 .gt. 0 .and. ire3 .gt. 0) then
            repk = 'TABLE'
            goto 9999
        endif
!
        call jeexin(nomob//'.DESC', ire1)
        if (ire1 .gt. 0) then
            call jelira(nomob//'.DESC', 'DOCU', cval=docu)
            if (docu .eq. 'CHNO') then
                repk = 'CHAM_NO'
                goto 9999
            else
                call rsdocu(docu, repk, iret)
                if (iret .ne. 0) ierd=1
                goto 9999
            endif
        endif
!
        call jeexin(nomob//'.CELD', ire1)
        if (ire1 .gt. 0) then
            repk='CHAM_ELEM'
            goto 9999
        endif
!
        call jeexin(nomob//'.PROL', ire1)
        if (ire1 .gt. 0) then
            call jeveuo(nomob//'.PROL', 'L', vk24=prol)
            if (prol(1) .eq. 'CONSTANTE' .or. prol(1) .eq. 'FONCTION' .or. prol(1)&
                .eq. 'NAPPE' .or. prol(1) .eq. 'FONCT_C') then
                repk='FONCTION'
                goto 9999
            endif
        endif
!
    else
        ierd=1
    endif
!
9999  continue
    repkz = repk
    call jedema()
end subroutine
