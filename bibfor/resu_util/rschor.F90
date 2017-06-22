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

subroutine rschor(noresz, nomsyz, nbordr, tabord, codret)
!
!      RESULTAT - CHAMP - QUELS NUMEROS D'ORDRE ?
!      - -        --                      --
!     ------------------------------------------------------------------
!     ENTREES:
!        NORESZ : NOM DU RESULTAT A EXAMINER
!        NOMSYZ : NOM SYMBOLIQUE DU CHAMP
!     SORTIES:
!        NBORDR : NOMBRE DE NUMEROS D'ORDRE POUR (NORESZ,NOMSYZ)
!        TABORD : LISTE DES NUMEROS D'ORDRE ; L'OBJET EST ALLOUE ICI.
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!     ------------------------------------------------------------------
!     REMARQUE : PROGRAMME INSPIRE DE RSUTNC
!_______________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: nbordr
!
    character(len=*) :: noresz, nomsyz, tabord
!
    integer :: codret
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
!
!
    integer :: iaux
    integer :: adtabo,  jtach
    integer :: nbtono
!
    character(len=16) :: nomsym
    character(len=19) :: noresu
    character(len=24) :: chextr
    character(len=24) :: valk(2)
    integer, pointer :: ordr(:) => null()
!
!====
! 1. PREALABLE
!====
!
    codret = 0
!
    iaux = lxlgut(noresz)
!              1234567890123456789
    noresu = '                   '
    noresu(1:iaux) = noresz(1:iaux)
!
    iaux = lxlgut(nomsyz)
!               1234567890123456
    nomsym = '                '
    nomsym(1:iaux) = nomsyz(1:iaux)
!
!====
! 2. EXPLORATION DE LA STRUCTURE DE RESULTATS
!====
! 2.1. ==> REPERAGES POUR LE COUPLE (NORESU,NOMSYM)
! NBTONO : NOMBRE TOTAL DE NUMEROS D'ORDRE DANS LA STRUCTURE NORESU
!
    call jelira(noresu//'.ORDR', 'LONUTI', nbtono)
    call jeveuo(noresu//'.ORDR', 'L', vi=ordr)
    call jenonu(jexnom(noresu//'.DESC', nomsym), iaux)
    call jeveuo(jexnum(noresu//'.TACH', iaux), 'L', jtach)
!
! 2.2. ==> ALLOCATION DU TABLEAU QUI CONTIENDRA LES NUMEROS D'ORDRE
!          SPECIFIQUES DU CHAMP SYMBOLIQUE. ON ALLOUE AU NOMBRE TOTAL,
!          MAIS CE N'EST PAS GRAVE.
!
    call wkvect(tabord, 'V V I', nbtono, adtabo)
!
! 2.3. ==> ON PARCOURT TOUS LES NUMEROS D'ORDRE DE LA STRUCTURE RESULTAT
!          QUAND ON TROUVE UN CHAMP ENREGISTRE CORRESPONDANT AU CHAMP
!          VOULU, ON LE MEMORISE
!
    nbordr = 0
    do iaux = 0 , nbtono - 1
        chextr = zk24(jtach+iaux)
        if (chextr .ne. ' ') then
            zi(adtabo+nbordr) = ordr(iaux+1)
            nbordr = nbordr + 1
        endif
    end do
!
!====
! 3. BILAN
!====
!
    if (codret .gt. 0) then
        valk(1) = noresu
        valk(2) = nomsym
        call utmess('A', 'UTILITAI4_30', nk=2, valk=valk)
    endif
!
end subroutine
