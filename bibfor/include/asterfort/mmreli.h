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
    subroutine mmreli(alias, nno, ndim, coorma, coorpt,&
                      ksi1, ksi2, dksi1, dksi2, alpha)
        character(len=8) :: alias
        integer :: nno
        integer :: ndim
        real(kind=8) :: coorma(27)
        real(kind=8) :: coorpt(3)
        real(kind=8) :: ksi1
        real(kind=8) :: ksi2
        real(kind=8) :: dksi1
        real(kind=8) :: dksi2
        real(kind=8) :: alpha
    end subroutine mmreli
end interface
