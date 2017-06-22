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
    subroutine mmmtas(nbdm, ndim, nnl, nne, nnm,&
                      nbcps, matrcc, matree, matrmm, matrem,&
                      matrme, matrce, matrcm, matrmc, matrec,&
                      matrff, matrfe, matrfm, matrmf, matref,&
                      mmat)
        integer :: nbdm
        integer :: ndim
        integer :: nnl
        integer :: nne
        integer :: nnm
        integer :: nbcps
        real(kind=8) :: matrcc(9, 9)
        real(kind=8) :: matree(27, 27)
        real(kind=8) :: matrmm(27, 27)
        real(kind=8) :: matrem(27, 27)
        real(kind=8) :: matrme(27, 27)
        real(kind=8) :: matrce(9, 27)
        real(kind=8) :: matrcm(9, 27)
        real(kind=8) :: matrmc(27, 9)
        real(kind=8) :: matrec(27, 9)
        real(kind=8) :: matrff(18, 18)
        real(kind=8) :: matrfe(18, 27)
        real(kind=8) :: matrfm(18, 27)
        real(kind=8) :: matrmf(27, 18)
        real(kind=8) :: matref(27, 18)
        real(kind=8) :: mmat(81, 81)
    end subroutine mmmtas
end interface
