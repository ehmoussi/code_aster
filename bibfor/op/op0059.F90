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

subroutine op0059()
!
    implicit none
!
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/dc_monocristal.h"
#include "asterfort/dc_polycristal.h"
#include "asterfort/dc_multifibre.h"
!
! person_in_charge: jean-michel.proix at edf.fr
!
!
! --------------------------------------------------------------------------------------------------
!
! OPERATEUR    DEFI_COMPOR
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nboccp, nboccm, nbocci
    character(len=8) :: sdcomp
    character(len=24) :: k24bid
!
! --------------------------------------------------------------------------------------------------
!
    call infmaj()

    call getres(sdcomp, k24bid, k24bid)
    call getfac('MONOCRISTAL', nboccm)
    call getfac('POLYCRISTAL', nboccp)
    call getfac('MULTIFIBRE' , nbocci)
!
    if (nboccm .gt. 0) then
!
!        MONOCRISTAL
!
        call dc_monocristal(nboccm, sdcomp)
!
    else if (nboccp.gt.0) then
!
!        POLYCRISTAL
!
        call dc_polycristal(nboccp, sdcomp)
!
    else if (nbocci.gt.0) then
!
!        MULTIFIBRE
!
        call dc_multifibre(nbocci, sdcomp)
!
    endif
!
end subroutine
