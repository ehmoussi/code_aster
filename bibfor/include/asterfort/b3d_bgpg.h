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
interface 
    subroutine b3d_bgpg(vg, biot0, poro0, xmg, vp0,&
                        bg, epsvt, epsvpg, epsvpw, pg)
        real(kind=8) :: vg
        real(kind=8) :: biot0
        real(kind=8) :: poro0
        real(kind=8) :: xmg
        real(kind=8) :: vp0
        real(kind=8) :: bg
        real(kind=8) :: epsvt
        real(kind=8) :: epsvpg
        real(kind=8) :: epsvpw
        real(kind=8) :: pg
    end subroutine b3d_bgpg
end interface 
