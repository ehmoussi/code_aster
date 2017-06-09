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

subroutine te0202(option, nomte)
!
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmfifi.h"
    character(len=16) :: nomte, option
!
!-----------------------------------------------------------------------
!
!     BUT : CALCUL DES OPTIONS NON LINEAIRES DES ELEMENTS DE
!          FISSURE JOINT
!
!     OPTION : FORC_NODA
!
!-----------------------------------------------------------------------
!
!
    integer :: igeom, icont, ivect, npg
    character(len=8) :: typmod(2)
!
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else
        typmod(1) = 'PLAN'
    endif
    typmod(2) = 'ELEMJOIN'
!
    npg=2
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTMR', 'L', icont)
    call jevech('PVECTUR', 'E', ivect)
!
    call nmfifi(npg, typmod, zr(igeom), zr(icont), zr(ivect))
!
end subroutine
