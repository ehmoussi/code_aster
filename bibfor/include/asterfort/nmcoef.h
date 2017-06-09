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
    subroutine nmcoef(noeu1, noeu2, typpil, nbno, cnsln,&
                      compo, vect, i, n, coef1,&
                      coef2, coefi)
        integer :: noeu1
        integer :: noeu2
        character(len=24) :: typpil
        integer :: nbno
        character(len=19) :: cnsln
        character(len=8) :: compo
        real(kind=8) :: vect(3)
        integer :: i
        integer :: n
        real(kind=8) :: coef1
        real(kind=8) :: coef2
        real(kind=8) :: coefi
    end subroutine nmcoef
end interface
