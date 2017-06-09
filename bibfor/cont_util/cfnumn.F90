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

subroutine cfnumn(defico, nno, posnno, numnno)
!
    implicit     none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: defico
    integer, intent(in) :: nno
    integer, intent(in) :: posnno(nno)
    integer, intent(out) :: numnno(nno)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! DONNE LES NUMEROS ABSOLUS DES NOEUDS DE CONTACT
!
! --------------------------------------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  NNO    : NOMBRE DE NOEUDS
! IN  POSNNO : INDICE DANS CONTNO DES NOEUDS
! OUT NUMNNO : INDICE ABSOLUS DES NOEUDS DANS LE MAILLAGE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ino, posno
    character(len=24) :: contno
    integer :: jnoco
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD CONTACT
!
    contno = defico(1:16)//'.NOEUCO'
    call jeveuo(contno, 'L', jnoco)
!
! --- NUMERO DES NOEUDS
!
    do ino = 1, nno
        posno = posnno(ino)
        numnno(ino) = zi(jnoco+posno-1)
    end do
!
    call jedema()
!
end subroutine
