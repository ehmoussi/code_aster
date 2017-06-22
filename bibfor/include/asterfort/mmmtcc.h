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
    subroutine mmmtcc(phasep, nnl, wpg, ffl, jacobi,&
                      coefac, matrcc)
        character(len=9) :: phasep
        integer :: nnl
        real(kind=8) :: wpg
        real(kind=8) :: ffl(9)
        real(kind=8) :: jacobi
        real(kind=8) :: coefac
        real(kind=8) :: matrcc(9, 9)
    end subroutine mmmtcc
end interface
