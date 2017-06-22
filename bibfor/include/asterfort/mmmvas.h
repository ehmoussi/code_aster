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
    subroutine mmmvas(ndim, nne, nnm, nnl, nbdm,&
                      nbcps, vectee, vectmm, vectcc, vectff,&
                      vtmp)
        integer :: ndim
        integer :: nne
        integer :: nnm
        integer :: nnl
        integer :: nbdm
        integer :: nbcps
        real(kind=8) :: vectee(27)
        real(kind=8) :: vectmm(27)
        real(kind=8) :: vectcc(9)
        real(kind=8) :: vectff(18)
        real(kind=8) :: vtmp(81)
    end subroutine mmmvas
end interface
