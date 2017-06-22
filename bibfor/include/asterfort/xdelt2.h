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
    subroutine xdelt2(elp, n, ndime, ksi,&
                      ptint, ndim, tabco, tabls, ipp, ip,&
                      delta)
        integer :: ndime
        integer :: ndim
        character(len=8) :: elp
        integer :: n(3)
        real(kind=8) :: ksi(ndim)
        real(kind=8) :: ptint(*)
        real(kind=8) :: tabco(*)
        real(kind=8) :: tabls(*)
        integer :: ipp
        integer :: ip
        real(kind=8) :: delta(ndime)
    end subroutine xdelt2
end interface 
