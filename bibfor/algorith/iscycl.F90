! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

function iscycl(ccycle, longcy)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: iscycl
    integer :: ccycle, longcy
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE)
!
! DETECTION D'UN CYCLE
!
! ----------------------------------------------------------------------
!
!
! CETTE ROUTINE DETECTE UN CYCLE DE TYPE 0/1 SUR UNE LONGUEUR DONNEE
!
! CYCLE LONGUEUR 3: 0 1 0 -> 4
!                   1 0 1 -> 10
!
! IN  CCYCLE : ENTIER CODE REPRESENTANT LE CYCLE
! IN  LONGCY : LONGUEUR DU CYCLE
!
! ----------------------------------------------------------------------
!
    iscycl = .false.
    if (longcy .eq. 3) then
        if ((ccycle.eq.4) .or. (ccycle.eq.10)) iscycl = .true.
    else if (longcy.eq.4) then
        if ((ccycle.eq.20) .or. (ccycle.eq.10)) iscycl = .true.
    else if (longcy.eq.15) then
        if ((ccycle.eq.21844) .or. (ccycle.eq.43690)) iscycl = .true.
    else if (longcy.eq.6) then
        if ((ccycle.eq.21) .or. (ccycle.eq.42)) iscycl = .true.
    else
        ASSERT(.false.)
    endif
end function
