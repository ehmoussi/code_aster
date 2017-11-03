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
interface
    subroutine pielas(ndim, npg, kpg, compor, typmod,&
                      mate, lgpg, vim, epsm,&
                      epsp, epsd, sigma, etamin, etamax,&
                      tau, copilo)
        integer :: lgpg
        integer :: npg
        integer :: ndim
        integer :: kpg
        character(len=16) :: compor(*)
        character(len=8) :: typmod(*)
        integer :: mate
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: epsm(6)
        real(kind=8) :: epsp(6)
        real(kind=8) :: epsd(6)
        real(kind=8) :: sigma(6)
        real(kind=8) :: etamin
        real(kind=8) :: etamax
        real(kind=8) :: tau
        real(kind=8) :: copilo(5, npg)
    end subroutine pielas
end interface
