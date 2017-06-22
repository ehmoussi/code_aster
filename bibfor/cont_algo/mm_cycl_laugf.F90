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

subroutine mm_cycl_laugf(pres, dist, coef_augm, lagr_norm)
!
implicit none
!
! person_in_charge: mickael.abbas at edf.fr
!
    real(kind=8), intent(in) :: pres(3)
    real(kind=8), intent(in) :: dist(3)
    real(kind=8), intent(in) :: coef_augm
    real(kind=8), intent(out) :: lagr_norm
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Augmented lagrangian (vectorial version)
!
! --------------------------------------------------------------------------------------------------
!
! In  pres      : pressure
! In  dist      : distance
! In  coef_augm : augmented coefficient
! Out lagr_norm : norm of augmented lagrangian
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: lagr_augm(3)
    integer :: idim
!
! --------------------------------------------------------------------------------------------------
!
    lagr_augm(1) = pres(1) + coef_augm *dist(1)
    lagr_augm(2) = pres(2) + coef_augm *dist(2)
    lagr_augm(3) = pres(3) + coef_augm *dist(3)
    lagr_norm = 0.d0
    do idim = 1, 3
        lagr_norm = lagr_augm(idim)*lagr_augm(idim) + lagr_norm
    end do
    lagr_norm = sqrt(lagr_norm)
end subroutine
