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

subroutine zzappa(num, liste, n, app)
    implicit none
#include "asterf_types.h"
!
!    ESTIMATEUR ZZ (2-EME VERSION 92)
!
! CETTE ROUTINE TESTE SI LE NUMERO NUM EST DANS LA LISTE LISTE
!        SI OUI : APP = .TRUE.
!        SI NON : APP = .FALSE.
!
    integer :: liste(1)
    aster_logical :: app
!-----------------------------------------------------------------------
    integer :: i, n, num
!-----------------------------------------------------------------------
    app = .false.
    do 1 i = 1, n
        if (num .eq. liste(i)) then
            app = .true.
        endif
  1 end do
end subroutine
