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

subroutine cufoco(numedd, resocu, cnunil)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resocu
    character(len=24) :: numedd
    character(len=24) :: cnunil
!
! ----------------------------------------------------------------------
!
! ROUTINE LIAISON_UNILATER (CALCUL)
!
! CALCUL DU VECTEUR ASSEMBLE DES FORCES DE LIAISON_UNILATER
!
! ----------------------------------------------------------------------
!
!
! IN  NUMEDD : NUME_DDL DE LA MATRICE
! IN  RESOCU : SD DE RESOLUTION DE LIAISON_UNILATER
! OUT CNUNIL : VECT_ASSE DES FORCES DE LIAISON_UNILATER
!
!
!
!
    integer :: neq, i
    real(kind=8), pointer :: vale(:) => null()
    real(kind=8), pointer :: atmu(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
    call jeveuo(cnunil(1:19)//'.VALE', 'E', vr=vale)
!
! --- CALCUL DU VECT_ASSE
!
    call jeveuo(resocu(1:14)//'.ATMU', 'L', vr=atmu)
    do i = 1, neq
        vale(i) = atmu(i)
    end do
!
    call jedema()
end subroutine
