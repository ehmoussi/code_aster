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
!
interface
    subroutine mmmtem(phase ,&
                      ndim  , nne   ,nnm   ,&
                      mprojn, mprojt,wpg   , jacobi,&
                      ffe   , ffm   , &
                      coefac, coefaf,coefff, lambda,&
                      rese  , nrese,&
                      matrem)
        character(len=4), intent(in) :: phase
        integer, intent(in) :: ndim, nne, nnm
        real(kind=8), intent(in) :: mprojn(3, 3), mprojt(3, 3)
        real(kind=8), intent(in) :: wpg, jacobi
        real(kind=8), intent(in) :: ffe(9), ffm(9)
        real(kind=8), intent(in) :: coefac, coefaf, coefff, lambda
        real(kind=8), intent(in) :: rese(3), nrese
        real(kind=8), intent(out) :: matrem(27, 27)
    end subroutine mmmtem
end interface
