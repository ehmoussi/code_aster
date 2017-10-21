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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1403
!
subroutine nonlinDSColumnVoid(column)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/ismaem.h"
#include "asterc/r8vide.h"
!
type(NL_DS_Column), intent(out) :: column
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Create void column
!
! --------------------------------------------------------------------------------------------------
!
! Out column           : column
!
! --------------------------------------------------------------------------------------------------
!
    column%name          = ' '
    column%l_vale_affe   = ASTER_FALSE
    column%l_vale_inte   = ASTER_FALSE
    column%l_vale_real   = ASTER_FALSE
    column%l_vale_cplx   = ASTER_FALSE
    column%l_vale_strg   = ASTER_FALSE
    column%vale_inte     = ismaem()
    column%vale_real     = r8vide()
    column%vale_cplx     = dcmplx(r8vide(),r8vide())
    column%vale_strg     = ' '
    column%mark          = ' '
    column%title(1:3)    = ' '
!
end subroutine
