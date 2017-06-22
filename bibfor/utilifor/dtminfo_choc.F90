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

subroutine dtminfo_choc(nlcase, nbnoli)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtminfo_choc : Print out information about the current choc state
!
#include "jeveux.h"
#include "asterfort/utmess.h"
#include "asterfort/codent.h"
!
!   -0.1- Input/output arguments
    integer          , intent(in)   :: nlcase
    integer          , intent(in)   :: nbnoli
!
!   -0.2- Local variables
    integer                      :: input, ind, base, digit, decal
    character(len=(13+4*nbnoli)) :: line, chaine

!
    do ind = 1, 13+4*nbnoli
        line(ind:ind) = '-'
    end do

    chaine = ' '
    do ind = 1, nbnoli
        decal = (ind-1)*4
        call codent(ind, 'D', chaine(decal+1:decal+2))
        chaine(decal+3:decal+4) = ' |'
    end do
    call utmess('I', 'DYNAMIQUE_91', nk=2, valk=[line, chaine])

    input = nlcase
    base = 2
    ind  = 1
    chaine = ' '
    chaine(1:1) = '|'
    do ind = 1, nbnoli
        decal = 1+(ind-1)*4
        digit = input - int(input/base)*base
        input = (input - digit)/base
        if (digit.eq.1) chaine(decal+1:decal+2) = ' x'
        chaine(decal+3:decal+4) = ' |'
    end do
    call utmess('I', 'DYNAMIQUE_92', nk=2, valk=[chaine, line])

end subroutine
