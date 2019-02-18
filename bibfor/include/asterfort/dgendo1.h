! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine dgendo1(em, ea, sya, b, syt, h, fcj, epsi_c, num,&
                       gt, gc, syc, alpha_c)
        real(kind=8), intent(in) :: em
        real(kind=8), intent(in) :: ea
        real(kind=8), intent(in) :: sya
        real(kind=8), intent(in) :: b
        real(kind=8), intent(in) :: syt
        real(kind=8), intent(in) :: h
        real(kind=8), intent(in) :: fcj
        real(kind=8), intent(in) :: epsi_c
        real(kind=8), intent(in) :: num
        real(kind=8), intent(inout) :: gt
        real(kind=8), intent(out) :: gc
        real(kind=8), intent(out) :: syc
        real(kind=8), intent(out) :: alpha_c
    end subroutine dgendo1
end interface
