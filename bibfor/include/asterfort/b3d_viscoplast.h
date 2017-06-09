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
    subroutine b3d_viscoplast(pg, etag, dt, epg0, dff3,&
                              xmg, bg, epsvpg, epspg6, epspfg6,&
                              vssd33, vssd33t, vplg33, vplg33t, dg3)
        real(kind=8) :: pg
        real(kind=8) :: etag
        real(kind=8) :: dt
        real(kind=8) :: epg0
        real(kind=8) :: dff3(3)
        real(kind=8) :: xmg
        real(kind=8) :: bg
        real(kind=8) :: epsvpg
        real(kind=8) :: epspg6(6)
        real(kind=8) :: epspfg6(6)
        real(kind=8) :: vssd33(3, 3)
        real(kind=8) :: vssd33t(3, 3)
        real(kind=8) :: vplg33(3, 3)
        real(kind=8) :: vplg33t(3, 3)
        real(kind=8) :: dg3(3)
    end subroutine b3d_viscoplast
end interface 
