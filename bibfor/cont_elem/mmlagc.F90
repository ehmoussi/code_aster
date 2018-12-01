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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmlagc(lambds, dlagrc, iresof, lambda)
!
implicit none
!
real(kind=8), intent(in) :: lambds, dlagrc
integer, intent(in) :: iresof
real(kind=8), intent(out) :: lambda
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get contact pressure
!
! --------------------------------------------------------------------------------------------------
!
! In  lambds           : contact pressure (fixed trigger)
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  iresof           : algorithm for friction
!                        0 - Fixed point
!                        1 - Newton
! Out lambda           : contact pressure
!
! --------------------------------------------------------------------------------------------------
!
    lambda = lambds
    if (iresof .ne. 0) then
        if (dlagrc .ne. 0) lambda = dlagrc
    endif
!
end subroutine
