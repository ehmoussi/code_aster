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

subroutine modexi(modelz, nomodz, iexi)
!.======================================================================
    implicit none
!
!     MODEXI  -- SI LA MODELISATION NOMODZ EXISTE DANS LE MODELE
!                MODELZ ALORS IEXI = 1
!                       SINON IEXI = 0
!
!   ARGUMENT        E/S  TYPE         ROLE
!    MODELZ          IN    K*     NOM DU MODELE
!    NOMODZ          IN    K*     NOM DE LA MODELISATION
!    IEXI            OUT   R      = 1 SI LA MODELISATION EXISTE
!                                     DANS LE MODELE
!                                 = 0 SINON
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
    character(len=*) :: modelz, nomodz
! -----  VARIABLES LOCALES
    integer :: repi
    character(len=8) :: modele
    character(len=16) :: nomte, nomodl
    character(len=19) :: nolig
    character(len=24) :: repk
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!-----------------------------------------------------------------------
    integer :: ialiel, iexi, igrel, iret, itypel, l
    integer :: nbgrel, nel
!-----------------------------------------------------------------------
    call jemarq()
!
! --- INITIALISATIONS :
!     ---------------
    modele = modelz
    iexi = 0
    repi = 0
    l = len(nomodz)
!
    nolig = modele//'.MODELE'
    call jeexin(nolig//'.LIEL', iret)
    if (iret .ne. 0) then
        call jelira(nolig//'.LIEL', 'NUTIOC', nbgrel)
! le nombre de grels du LIGREL du modele est nul.
        ASSERT(nbgrel.gt.0)
        nomodl=' '
        do igrel = 1, nbgrel
            call jeveuo(jexnum(nolig//'.LIEL', igrel), 'L', ialiel)
            call jelira(jexnum(nolig//'.LIEL', igrel), 'LONMAX', nel)
            itypel= zi(ialiel -1 +nel)
            call jenuno(jexnum('&CATA.TE.NOMTE', itypel), nomte)
            call dismoi('MODELISATION', nomte, 'TYPE_ELEM', repk=repk)
            nomodl=repk(1:16)
            if (nomodl(1:l) .eq. nomodz(1:l)) then
                iexi = 1
                goto 20
            endif
        end do
 20     continue
    endif
    call jedema()
end subroutine
