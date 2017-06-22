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

subroutine tresu_ordgrd(valr, ignore, compare, mcf, iocc)
    implicit none
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
    real(kind=8), intent(in) :: valr
    aster_logical, intent(out) :: ignore
    real(kind=8), intent(out) :: compare
    character(len=*), intent(in), optional :: mcf
    integer, intent(in), optional :: iocc
! person_in_charge: mathieu.courtois@edf.fr
!
!   Read the ORDRE_GRANDEUR keyword in the value of VALE_CALC(=valr) is null
!
!   Optional keyword:
!   - By default, mcf=' '. If it is present, iocc is mandatory.
!
    integer :: nord, uioc
    character(len=24) :: umcf
!
    ASSERT(ENSEMBLE2(mcf, iocc))
    if (absent(mcf)) then
        umcf = ' '
        uioc = 0
    else
        umcf = mcf
        uioc = iocc
    endif
!
    ignore = .false.
    compare = 1.d0
    if (abs(valr) .le. r8prem()) then
        call getvr8(umcf, 'ORDRE_GRANDEUR', iocc=iocc, nbval=0, nbret=nord)
        if (nord .eq. 0) then
            ignore = .true.
        else
            call getvr8(umcf, 'ORDRE_GRANDEUR', iocc=iocc, scal=compare)
        endif
    endif
!
end subroutine tresu_ordgrd
