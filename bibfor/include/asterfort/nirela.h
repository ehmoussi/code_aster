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
    subroutine nirela(irela, jp, gm, gp, am,&
                      ap, bp, boa, aa, bb,&
                      daa, dbb, dboa, d2boa, iret)
        integer, intent(in) :: irela
        real(kind=8), intent(in) :: jp
        real(kind=8), intent(in) :: gm
        real(kind=8), intent(in) :: gp
        real(kind=8), intent(out) :: am
        real(kind=8), intent(out) :: ap
        real(kind=8), intent(out) :: bp
        real(kind=8), intent(out) :: boa
        real(kind=8), intent(out) :: aa
        real(kind=8), intent(out) :: bb
        real(kind=8), intent(out) :: daa
        real(kind=8), intent(out) :: dbb
        real(kind=8), intent(out) :: dboa
        real(kind=8), intent(out) :: d2boa
        integer, intent(out) :: iret
    end subroutine nirela
end interface
