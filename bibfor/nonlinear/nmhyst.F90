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

subroutine nmhyst(amort, vitplu, cnhyst)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
    character(len=19) :: amort
    character(len=19) :: vitplu, cnhyst
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DES FORCES D'AMORTISSEMENT HYSTERETIQUE
!
! ----------------------------------------------------------------------
!
!
! IN  VITPLU : VITESSE COURANTE
! IN  AMORT  : MATR_ASSE AMORTISSEMENT
! OUT CNHYST : VECT_ASSE FORCES AMORTISSEMENT
!
!
!
!
    integer ::  jamor
    real(kind=8), pointer :: hyst(:) => null()
    real(kind=8), pointer :: vitp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES OBJETS JEVEUX
!
    call jeveuo(vitplu(1:19)//'.VALE', 'L', vr=vitp)
    call jeveuo(amort(1:19) //'.&INT', 'L', jamor)
    call jeveuo(cnhyst(1:19)//'.VALE', 'E', vr=hyst)
!
! --- CALCUL FORCES AMORTISSEMENT
!
    call mrmult('ZERO', jamor, vitp, hyst, 1,&
                .true._1)
!
    call jedema()
end subroutine
