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

subroutine cfposn(defico, posmai, posnno, nnomai)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfnben.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    integer :: posmai
    integer :: posnno(9)
    integer :: nnomai
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! INDICES DANS CONTNO DES NOEUDS POUR UNE MAILLE DONNEE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  POSMAI : INDICE DE LA MAILLE (DANS SD CONTACT)
! OUT POSNNO : INDICES DANS CONTNO DES NOEUDS
! OUT NNOMAI : NOMBRE DE NOEUDS DE LA MAILLE (DANS LES SD DE CONTACT)
!
!
!
!
    integer :: nbnmax
    parameter   (nbnmax = 9)
!
    character(len=24) :: nomaco, pnoma
    integer :: jnoma, jpono
    integer :: ino, jdec
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD CONTACT
!
    nomaco = defico(1:16)//'.NOMACO'
    pnoma = defico(1:16)//'.PNOMACO'
    call jeveuo(nomaco, 'L', jnoma)
    call jeveuo(pnoma, 'L', jpono)
!
! --- NOMBRE DE NOEUDS ATTACHES A CETTE MAILLE
!
    call cfnben(defico, posmai, 'CONNEX', nnomai)
    ASSERT(nnomai.le.nbnmax)
!
! --- NUMERO DES NOEUDS ATTACHES A CETTE MAILLE
!
    jdec = zi(jpono+posmai-1)
    do ino = 1, nnomai
        posnno(ino) = zi(jnoma+jdec+ino-1)
    end do
!
    call jedema()
end subroutine
