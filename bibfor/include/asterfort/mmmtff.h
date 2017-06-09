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
    subroutine mmmtff(phasep, ndim, nbcps, nnl, wpg,&
                      ffl, jacobi, tau1, tau2, rese,&
                      nrese, lambda, coefaf, coefff, matrff)
        character(len=9) :: phasep
        integer :: ndim
        integer :: nbcps
        integer :: nnl
        real(kind=8) :: wpg
        real(kind=8) :: ffl(9)
        real(kind=8) :: jacobi
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: rese(3)
        real(kind=8) :: nrese
        real(kind=8) :: lambda
        real(kind=8) :: coefaf
        real(kind=8) :: coefff
        real(kind=8) :: matrff(18, 18)
    end subroutine mmmtff
end interface
