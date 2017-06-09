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
    subroutine mmmtex(ndexfr, ndim, nnl, nne, nnm,&
                      nbcps, matrff, matrfe, matrfm, matref,&
                      matrmf)
        integer :: ndexfr
        integer :: ndim
        integer :: nnl
        integer :: nne
        integer :: nnm
        integer :: nbcps
        real(kind=8) :: matrff(18, 18)
        real(kind=8) :: matrfe(18, 27)
        real(kind=8) :: matrfm(18, 27)
        real(kind=8) :: matref(27, 18)
        real(kind=8) :: matrmf(27, 18)
    end subroutine mmmtex
end interface
