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

subroutine check_homo_grma(cara, nval)
    implicit none
    character(len=*), intent(in) :: cara(*)
    integer, intent(in) :: nval
!
!   AFFE_CARA_ELEM
!   Vérifie la présence de R_DEBUT et R_FIN
!
#include "asterfort/utmess.h"
! ----------------------------------------------------------------------
    integer, parameter :: nk = 4
    character(len=3) :: tcar(nk)
    integer :: nv, i, j
    character(len=8) :: carpou(nk)
!
    data carpou /'R_DEBUT', 'R_FIN', 'EP_DEBUT', 'EP_FIN'/
!
    nv = min(4, nval)
    tcar = '   '
    do i = 1, nv
        do j = 1, nk
            if (cara(i) .eq. carpou(j)) then
                tcar(j) = cara(i)
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
end subroutine
