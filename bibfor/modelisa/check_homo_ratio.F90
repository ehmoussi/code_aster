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

subroutine check_homo_ratio(cara, vale, nval)
    implicit none
    character(len=*), intent(in) :: cara(*)
    real(kind=8), intent(in) :: vale(*)
    integer, intent(in) :: nval
!
!   AFFE_CARA_ELEM
!   Check the consistency of properties R1, R2, EP1, EP2 for the beam elements
!   with homothetic section
!
#include "asterf_debug.h"
#include "asterfort/utmess.h"
! ----------------------------------------------------------------------
    integer, parameter :: nk = 4
    character(len=3) :: tcar(nk)
    real(kind=8) :: tval(nk), rratio, eratio, homo
    real(kind=8) :: valr(6)
    integer :: nv, i, j
    character(len=3) :: carpou(nk)
!
    data carpou /'R1', 'R2', 'EP1', 'EP2'/
!
!   copy the properties is the expected order
    nv = min(4, nval)
    tval = 0.d0
    tcar = '   '
    do i = 1, nv
        do j = 1, nk
            if (cara(i) .eq. carpou(j)) then
                tcar(j) = cara(i)
                tval(j) = vale(i)
                exit
            endif
        end do
    end do
!
    if (tcar(1)(1:1).eq. ' ')then
        call utmess('F', 'MODELISA5_54', sk=carpou(1))
    endif
    if (tcar(2)(1:1).eq. ' ')then
        call utmess('F', 'MODELISA5_54', sk=carpou(2))
    endif
!
!   default: EPi = Ri
    if (tcar(3)(1:1) .eq. ' ') then
        tval(3) = tval(1)
    endif
    if (tcar(4)(1:1) .eq. ' ') then
        tval(4) = tval(2)
    endif
#ifdef __DEBUG_ALL__
    write(6,*) MARKER, "POUT/CERCL/CARA:", tval(1), tval(2), tval(3), tval(4)
#endif
!
    rratio = tval(2) / tval(1)
    eratio = tval(4) / tval(3)
    homo = abs((rratio - eratio) / rratio)
#ifdef __DEBUG_ALL__
    write(6,*) MARKER, "POUT/CERCL/HOMO:", rratio, eratio, homo
#endif
    if (homo .gt. 1.0d-2) then
        valr(1:4) = tval(1:4)
        valr(5) = rratio
        valr(6) = eratio
        call utmess('A', 'POUTRE0_4', nr=6, valr=valr)
    endif
!
end subroutine
