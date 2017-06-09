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

subroutine mmextm(defico, cnsmul, posmae, mlagr)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit      none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfnumn.h"
#include "asterfort/cfposn.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: posmae
    character(len=19) :: cnsmul
    character(len=24) :: defico
    real(kind=8) :: mlagr(9)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! EXTRACTION D'UN MULTIPLICATEUR DE LAGRANGE SUR LES NOEUDS D'UNE MAILLE
! ESCLAVE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE DEFINITION DU CONTACT
! IN  CNSMUL : CHAM_NO_SIMPLE REDUIT AUX DDLS DU MULTIPLICATEUR EXTRAIT
! IN  POSMAE : INDICE DE LA MAILLE ESCLAVE
! OUT MLAGR  : MULTIPLICATEURS SUR LES NOEUDS ESCLAVES
!
!
!
!
    integer :: nbnmax
    parameter    (nbnmax = 9)
!
    integer :: ino, nnomai
    integer :: numnno(nbnmax), posnno(nbnmax)
    real(kind=8), pointer :: cnsv(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    do ino = 1,nbnmax
        mlagr(ino) = 0.d0
    end do
!
! --- NUMEROS DANS SD CONTACT DES NOEUDS DE LA MAILLE ESCLAVE
!
    call cfposn(defico, posmae, posnno, nnomai)
    ASSERT(nnomai.le.nbnmax)
!
! --- NUMEROS ABSOLUS DES NOEUDS DE LA MAILLE ESCLAVE
!
    call cfnumn(defico, nnomai, posnno, numnno)
!
! --- EXTRACTION DU MULTIPLICATEUR
!
    call jeveuo(cnsmul//'.CNSV', 'L', vr=cnsv)
    do ino = 1, nnomai
        mlagr(ino) = cnsv(numnno(ino))
    end do
!
    call jedema()
end subroutine
