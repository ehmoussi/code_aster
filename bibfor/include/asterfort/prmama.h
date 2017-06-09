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
    subroutine prmama(iprod, amat, na, na1, na2,&
                      bmat, nb, nb1, nb2, cmat,&
                      nc, nc1, nc2, ier)
        integer :: nc
        integer :: nb
        integer :: na
        integer :: iprod
        real(kind=8) :: amat(na, *)
        integer :: na1
        integer :: na2
        real(kind=8) :: bmat(nb, *)
        integer :: nb1
        integer :: nb2
        real(kind=8) :: cmat(nc, *)
        integer :: nc1
        integer :: nc2
        integer :: ier
    end subroutine prmama
end interface
