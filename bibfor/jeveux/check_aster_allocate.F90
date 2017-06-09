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

subroutine check_aster_allocate(init)
use allocate_module
! person_in_charge: jacques.pellet at edf.fr
    implicit none
    integer, optional, intent(in) :: init
!
! --------------------------------------------------------------------------
! verifier que les objets alloues par as_allocate ont bien ete desalloues
! init=0 => on (re)initialise la variable du common : cuvtrav=0
! --------------------------------------------------------------------------
!
#include "jeveux_private.h"
#include "asterc/jdcget.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
    integer, save :: icode = -1
!
    if (present(init)) then
        ASSERT (init.eq.0)
        cuvtrav=0.d0
    endif
!
    if (abs(cuvtrav) > r8prem()) then
        call utmess('A', 'DVP_6', sr=cuvtrav*lois/1.e6)
        if (icode < 0) then
            icode = jdcget('icode')
        endif
        if (icode == 1) then
            ASSERT(abs(cuvtrav) < r8prem())
        endif
        call deallocate_all_slvec()
    endif
!
end subroutine
