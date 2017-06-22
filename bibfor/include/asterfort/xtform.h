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
    subroutine xtform(ndim, typmae, typmam, typmac, nne,&
                      nnm, nnc, coore, coorm, coorc,&
                      ffe, ffm, dffc)
        integer :: ndim
        character(len=8) :: typmae
        character(len=8) :: typmam
        character(len=8) :: typmac
        integer :: nne
        integer :: nnm
        integer :: nnc
        real(kind=8) :: coore(3)
        real(kind=8) :: coorm(3)
        real(kind=8) :: coorc(2)
        real(kind=8) :: ffe(20)
        real(kind=8) :: ffm(20)
        real(kind=8) :: dffc(3, 9)
    end subroutine xtform
end interface
