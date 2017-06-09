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

subroutine op0136()
    implicit none
!     COMMANDE POST_FATIGUE
!     ------------------------------------------------------------------
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/pofape.h"
#include "asterfort/pofaqu.h"
#include "asterfort/pofaun.h"
#include "asterfort/titre.h"
    integer :: n1
    character(len=8) :: typcha
!     ------------------------------------------------------------------
!
    call infmaj()
    call getvtx(' ', 'CHARGEMENT', scal=typcha, nbret=n1)
!
!     --- CHARGEMENT PUREMENT UNAXIAL ---
!
    if (typcha .eq. 'UNIAXIAL') then
        call pofaun()
!
!     --- CHARGEMENT MULTIAXIAL ---
!
    else if (typcha .eq. 'MULTIAXI') then
        call pofape()
!
!     --- CHARGEMENT QUELCONQUE (ENDOMMAGEMENT DE LEMAITRE) ---
!
    else if (typcha .eq. 'QUELCONQ') then
        call pofaqu()
    endif
    call titre()
!
end subroutine
