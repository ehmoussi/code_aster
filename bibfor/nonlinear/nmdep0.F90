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

subroutine nmdep0(oper, solalg)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/nmchso.h"
    character(len=3) :: oper
    character(len=19) :: solalg(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! MISE A ZERO DE DEPDEL
!
! ----------------------------------------------------------------------
!
!
! IN  OPER   : TYPE OPERATION
!               ON  - ON MET &&CNPART.ZERO
!               OFF - ON MET DEPDEL
! I/O SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
! ----------------------------------------------------------------------
!
    character(len=19) :: depde0, depdel
!
! ----------------------------------------------------------------------
!
    if (oper .eq. 'ON ') then
        depde0 = '&&CNPART.ZERO'
        call nmchso(solalg, 'SOLALG', 'DEPDEL', depde0, solalg)
    else if (oper.eq.'OFF') then
        depdel = '&&NMCH2P.DEPDEL'
        call nmchso(solalg, 'SOLALG', 'DEPDEL', depdel, solalg)
    else
        ASSERT(.false.)
    endif
!
end subroutine
