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

subroutine cengra(noma, nmaabs, coorg)
    implicit none
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/panbno.h"
    integer :: nmaabs
    real(kind=8) :: coorg(3)
    character(len=8) :: noma
!
!
!                 CALCUL DU CENTRE DE GRAVITE D'UNE MAILLE
!
!     ENTREE
!       NOMA     : NOM DU MAILLAGE
!       NMAABS   : INDICE DE LA MAILLE
!
!     SORTIE
!       COORG    : COORDONNEES DU CENTRE DE GRAVITE DE LA MAILLE
!
!     ------------------------------------------------------------------
!
    integer :: ino, itypma,   jconx2,  nbnott(3), nuno
    integer, pointer :: connex(:) => null()
    real(kind=8), pointer :: vale(:) => null()
    integer, pointer :: typmail(:) => null()
! ----------------------------------------------------------------------
    call jemarq()
!
!     RECUPERATION DES DONNEES DU MAILLAGE
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
    call jeveuo(noma//'.TYPMAIL', 'L', vi=typmail)
!
    itypma = typmail(nmaabs)
    call panbno(itypma, nbnott)
!
!     CALCUL DES COORDONNEES DU CENTRE DE GRAVITE
    coorg(1) = 0
    coorg(2) = 0
    coorg(3) = 0
!
    do 10 ino = 1, nbnott(1)
        nuno = connex(zi(jconx2+nmaabs-1)+ino-1)
!
        coorg(1) = coorg(1) + vale(3*(nuno-1)+1)
        coorg(2) = coorg(2) + vale(3*(nuno-1)+2)
        coorg(3) = coorg(3) + vale(3*(nuno-1)+3)
10  end do
    coorg(1) = coorg(1) / nbnott(1)
    coorg(2) = coorg(2) / nbnott(1)
    coorg(3) = coorg(3) / nbnott(1)
!
    call jedema()
end subroutine
