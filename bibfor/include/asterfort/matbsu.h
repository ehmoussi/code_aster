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
    subroutine matbsu(nb1, xr, npgsr, intsn, b1mnc,&
                      b2mnc, b1mni, b2mni, b1mri, b2mri,&
                      b1src, b2src, b1su, b2su)
        integer :: nb1
        real(kind=8) :: xr(*)
        integer :: npgsr
        integer :: intsn
        real(kind=8) :: b1mnc(3, 51)
        real(kind=8) :: b2mnc(3, 51)
        real(kind=8) :: b1mni(3, 51)
        real(kind=8) :: b2mni(3, 51)
        real(kind=8) :: b1mri(3, 51, 4)
        real(kind=8) :: b2mri(3, 51, 4)
        real(kind=8) :: b1src(2, 51, 4)
        real(kind=8) :: b2src(2, 51, 4)
        real(kind=8) :: b1su(5, 51)
        real(kind=8) :: b2su(5, 51)
    end subroutine matbsu
end interface
