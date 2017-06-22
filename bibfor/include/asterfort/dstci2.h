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
    subroutine dstci2(dci, carat3, hft2, dfc, dmc,&
                      bca, an, am)
        real(kind=8) :: dci(2, 2)
        real(kind=8) :: carat3(*)
        real(kind=8) :: hft2(2, 6)
        real(kind=8) :: dfc(3, 2)
        real(kind=8) :: dmc(3, 2)
        real(kind=8) :: bca(2, 3)
        real(kind=8) :: an(3, 9)
        real(kind=8) :: am(3, 6)
    end subroutine dstci2
end interface
