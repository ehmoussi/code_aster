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
    subroutine ar_dlanv2(a, b, c, d, rt1r,&
                      rt1i, rt2r, rt2i, cs, sn)
        real(kind=8) :: a
        real(kind=8) :: b
        real(kind=8) :: c
        real(kind=8) :: d
        real(kind=8) :: rt1r
        real(kind=8) :: rt1i
        real(kind=8) :: rt2r
        real(kind=8) :: rt2i
        real(kind=8) :: cs
        real(kind=8) :: sn
    end subroutine ar_dlanv2
end interface
