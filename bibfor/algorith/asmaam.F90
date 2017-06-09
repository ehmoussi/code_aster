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

subroutine asmaam(meamor, numedd, lischa, matamo)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/asmatr.h"
    character(len=19) :: meamor
    character(len=24) :: numedd
    character(len=19) :: matamo
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! ASSEMBLAGE DE LA MATRICE D'AMORTISSEMENT GLOBALE
!
! ----------------------------------------------------------------------
!
!
! IN  MEAMOR : MATRICES ELEMENTAIRES D'AMORTISSEMENT
! IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
! IN  LISCHA : SD L_CHARGE
! OUT MATAMO : MATRICE D'AMORTISSEMENT ASSEMBLEE
!
! ----------------------------------------------------------------------
!
    call asmatr(1, meamor, ' ', numedd, &
                lischa, 'ZERO', 'V', 1, matamo)
end subroutine
