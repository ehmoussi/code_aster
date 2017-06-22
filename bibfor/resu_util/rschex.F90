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

subroutine rschex(noresz, nomsym, codret)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/lxlgut.h"
    integer :: codret
    character(len=*) :: noresz, nomsym
!      RESULTAT - NOMSYM EXISTE-T-IL ?
!
!     ENTREES:
!        NORESZ : NOM DU RESULTAT A EXAMINER
!        NOMSYM : NOM SYMBOLIQUE DU CHAMP
!     SORTIES:
!        CODRET : CODE D'EXISTENCE
!                 = 0 N'EXISTE PAS
!                 /= 0 EXISTE
!
!     ------------------------------------------------------------------
!
    integer :: iaux, nbtono, jordr, jtach
    character(len=19) :: noresu
!     ------------------------------------------------------------------
!
    codret = 0
!
    iaux = lxlgut(noresz)
!               1234567890123456789
    noresu = '                   '
    noresu(1:iaux) = noresz(1:iaux)
!
    call jelira(noresu//'.ORDR', 'LONUTI', nbtono)
    call jeveuo(noresu//'.ORDR', 'L', jordr)
    call jenonu(jexnom(noresu//'.DESC', nomsym), iaux)
    call jeveuo(jexnum(noresu//'.TACH', iaux), 'L', jtach)
!
! --- ON PARCOURT TOUS LES NUMEROS D'ORDRE DE LA STRUCTURE RESULTAT
!     QUAND ON TROUVE UN CHAMP ENREGISTRE, ON SORT
!
    do iaux = 0 , nbtono - 1
        if (zk24(jtach+iaux) .ne. ' ') then
            codret = 7
            goto 999
        endif
    end do
!
999 continue
!
end subroutine
