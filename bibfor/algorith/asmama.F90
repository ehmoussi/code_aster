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

subroutine asmama(memasz, medirz, numedd, lischa,&
                  matmas)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/asmatr.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=24) :: numedd
    character(len=19) :: lischa
    character(len=*) :: memasz, matmas, medirz
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! ASSEMBLAGE DE LA MATRICE DE MASSE GLOBALE
!
! ----------------------------------------------------------------------
!
!
! IN  MEMASS : MATRICES ELEMENTAIRES DE MASSE
! IN  MEDIRZ : MATRICES ELEMENTAIRES DE DIRICHLET
! IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
! IN  LISCHA : SD L_CHARGE
! OUT MATMAS : MATRICE DE MASSE ASSEMBLEE
!
!
!
!
    character(len=19) :: mediri, memass, tlimat(2)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    mediri = medirz
    memass = memasz
!
    if (mediri .eq. ' ') then
        call asmatr(1, memass, ' ', numedd, &
                    lischa, 'ZERO', 'V', 1, matmas)
    else
        tlimat(1) = memass
        tlimat(2) = mediri
        call asmatr(2, tlimat, ' ', numedd, &
                    lischa, 'ZERO', 'V', 1, matmas)
    endif
!
    call jedema()
end subroutine
