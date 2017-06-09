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

!
!
interface
    subroutine edgmat(fami   , kpg   , ksp   , imat  , c1 ,&
                      zalpha , temp  , dt    , mum   , mu ,&
                      troiskm, troisk, ani   , m     , n  ,&
                      gamma  , zcylin)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: imat
        character(len=1), intent(in) :: c1
        real(kind=8), intent(in) :: zalpha
        real(kind=8), intent(in) :: temp
        real(kind=8), intent(in) :: dt
        real(kind=8), intent(out) :: mum
        real(kind=8), intent(out) :: mu
        real(kind=8), intent(out) :: troiskm
        real(kind=8), intent(out) :: troisk
        real(kind=8), intent(out) :: ani(6, 6)
        real(kind=8), intent(out) :: m(3)
        real(kind=8), intent(out) :: n(3)
        real(kind=8), intent(out) :: gamma(3)
        logical, intent(out) :: zcylin
    end subroutine edgmat
end interface
