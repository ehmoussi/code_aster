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

subroutine op0028()
!
implicit none
!
#include "asterc/getres.h"
#include "asterfort/dfllad.h"
#include "asterfort/dflldb.h"
#include "asterfort/dfllec.h"
#include "asterfort/dfllty.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
!
! person_in_charge: mickael.abbas at edf.fr
!

!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: sdlist
    character(len=16) :: k16bid
    character(len=16) :: metlis
    real(kind=8) :: dtmin
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infmaj()
    call infniv(ifm, niv)
!
! --- NOM DU CONCEPT
!
    call getres(sdlist, k16bid, k16bid)
!
! --- LECTURE DU TYPE DE CONSTRUCTION DE LA LISTE D'INSTANTS
!
    call dfllty(sdlist, metlis, dtmin)
!
! --- LECTURE DES ECHECS
!
    call dfllec(sdlist, dtmin)
!
! --- ADAPTATION SEULEMENT SI METHODE AUTO
!
    if (metlis .eq. 'AUTO') then
        call dfllad(sdlist)
    endif
!
! --- DEBUG
!
    if (niv .ge. 2) then
        call dflldb(sdlist, ifm)
    endif

end subroutine
