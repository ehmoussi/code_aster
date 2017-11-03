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
!
subroutine calcGetDataTher(list_load, model    , mate       , cara_elem,&
                           temp_prev, incr_temp, compor_ther, theta)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/ntdoth.h"
#include "asterfort/getvid.h"
#include "asterfort/nxdocc.h"
#include "asterfort/getvr8.h"
!
character(len=19), intent(out) :: list_load
character(len=24), intent(out) :: model, mate, cara_elem
character(len=19), intent(out) :: temp_prev, incr_temp
character(len=24), intent(out) :: compor_ther
real(kind=8), intent(out) :: theta
!
! --------------------------------------------------------------------------------------------------
!
! Command CALCUL
!
! Get data for thermics
!
! --------------------------------------------------------------------------------------------------
!
! Out list_load        : name of datastructure for list of loads
! Out model            : name of model
! Out mate             : name of material characteristics (field)
! Out cara_elem        : name of elementary characteristics (field)
! Out temp_prev        : temperature at beginning of step
! Out incr_temp        : increment of temperature
! Out compor_ther      : name of comportment definition (field)
! Out theta            : parameter for theta-scheme
!
! --------------------------------------------------------------------------------------------------
!
    list_load = '&&OP0026.LISCHA'
    cara_elem = '&&OP0026.CARELE'
    model     = ' '
    mate      = ' '
    theta     = 0.d0
!
! - Get parameters from command file
!
    call ntdoth(model, mate, cara_elem, list_load)
!
! - Get displacements
!
    call getvid(' ', 'TEMP', scal = temp_prev)
    call getvid(' ', 'INCR_TEMP', scal = incr_temp)
!
! - Get theta
!
    call getvr8(' ', 'PARM_THETA', scal = theta)
!
! - Get comportment
!
    call nxdocc(model, compor_ther)
!
end subroutine
