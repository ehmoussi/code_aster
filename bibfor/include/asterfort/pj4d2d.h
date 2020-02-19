! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine pj4d2d(tria3, itr, geom1, coorno, nbno, nunos,&
                      cooele, xg)
        integer, intent(in) :: tria3(*)
        integer, intent(in) :: itr
        real(kind=8), intent(in)  :: geom1(*)
        real(kind=8), intent(in)  :: coorno(3)
        integer, intent(in) :: nbno
        integer, intent(in) :: nunos(*)
        real(kind=8), intent(out) ::  cooele(*)
        real(kind=8), intent(out) ::  xg(2)
    end subroutine pj4d2d
end interface
