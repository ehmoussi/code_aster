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
    subroutine xnewto(elrefp, name, n, ndime,&
                       ptxx, ndim, tabco, tabls,&
                       ipp, ip, itemax,&
                       epsmax, ksi, exit, dekker)
        integer :: ndime
        integer :: ndim
        character(len=8) :: elrefp
        character(len=6) :: name
        integer :: n(3)
        real(kind=8) :: ptxx(*)
        real(kind=8) :: tabls(*)
        real(kind=8) :: tabco(*)
        integer :: ipp
        integer :: ip
        integer :: itemax
        real(kind=8) :: epsmax
        real(kind=8) :: ksi(ndime)
        integer, intent(inout), optional :: exit(2)
        real(kind=8), intent(in), optional :: dekker(4*ndime)
    end subroutine xnewto
end interface
