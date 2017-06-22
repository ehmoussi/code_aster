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
    subroutine fonno6(resu, noma, ndim, ina, nbnose,&
                      iseg, nseg, noe, indr, nbnoel,&
                      vnor, vdir, basseg, vect, sens)
        integer :: ndim
        character(len=8) :: resu
        character(len=8) :: noma
        integer :: ina
        integer :: nbnose
        integer :: iseg
        integer :: nseg
        integer :: noe(4, 4)
        integer :: indr(2)
        integer :: nbnoel
        real(kind=8) :: vnor(2, 3)
        real(kind=8) :: vdir(2, 3)
        character(len=19) :: basseg
        real(kind=8) :: vect(3)
        real(kind=8) :: sens
    end subroutine fonno6
end interface
