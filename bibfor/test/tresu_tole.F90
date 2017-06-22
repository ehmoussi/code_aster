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

subroutine tresu_tole(tole, prec, mcf, iocc)
    implicit none
    real(kind=8), intent(out) :: tole
    real(kind=8), intent(out), optional :: prec
    character(len=*), intent(in), optional :: mcf
    integer, intent(in), optional :: iocc
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
!
!   Read the TOLE_MACHINE keyword
!
!   This keyword contains one or two values. In this case, the first one is the
!   tolerance of the non regression test and the second is the precision used
!   to find the time (or another parameter) in the result data structure.
!
!   Optional keywords:
!   - Only tole is mandatory.
!   - By default, mcf=' '. If it is present, iocc is mandatory.
!
    integer :: np, uioc
    real(kind=8) :: epsir(2)
    character(len=24) :: umcf
!   to print the message only once
    aster_logical, save :: ipass = .false.
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
    epsir(1) = 1.d-6
    epsir(2) = 1.d-6
!
    call getvr8(umcf, 'TOLE_MACHINE', iocc=uioc, nbval=0, nbret=np)
    np = -np
    if (np .eq. 1) then
        call getvr8(umcf, 'TOLE_MACHINE', iocc=uioc, scal=epsir(1))
        epsir(2) = epsir(1)
    else if (np .eq. 2) then
        call getvr8(umcf, 'TOLE_MACHINE', iocc=uioc, nbval=2, vect=epsir)
    else
        ASSERT(np .eq. 0)
    endif
!
#ifdef TEST_STRICT
!   Does not use TOLE_MACHINE (except for the parameter) if TEST_STRICT
    epsir(1) = 1.d-6
    if (.not. ipass) then
        call utmess('I', 'TEST0_6', sr=epsir(1))
    endif
#endif
    ipass = .true.
!
    tole = epsir(1)
    if (present(prec)) then
        prec = epsir(2)
    endif
end subroutine
