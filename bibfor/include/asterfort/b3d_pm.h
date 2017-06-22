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
    subroutine b3d_pm(vg, vp0, dv0, depst6, ssg6,&
                      dg3, epspg6, epspfg6, etag, bg,&
                      xmg, pg, dt, epg0, vw0,&
                      poro0, biot0, xwsat, pw1, bw1,&
                      epsvpw, vplg33, vplg33t, e0, rt0,&
                      ept0, erreur, xwns, mfr, pw0,&
                      dpw, vw1)
        real(kind=8) :: vg
        real(kind=8) :: vp0
        real(kind=8) :: dv0
        real(kind=8) :: depst6(6)
        real(kind=8) :: ssg6(6)
        real(kind=8) :: dg3(3)
        real(kind=8) :: epspg6(6)
        real(kind=8) :: epspfg6(6)
        real(kind=8) :: etag
        real(kind=8) :: bg
        real(kind=8) :: xmg
        real(kind=8) :: pg
        real(kind=8) :: dt
        real(kind=8) :: epg0
        real(kind=8) :: vw0
        real(kind=8) :: poro0
        real(kind=8) :: biot0
        real(kind=8) :: xwsat
        real(kind=8) :: pw1
        real(kind=8) :: bw1
        real(kind=8) :: epsvpw
        real(kind=8) :: vplg33(3, 3)
        real(kind=8) :: vplg33t(3, 3)
        real(kind=8) :: e0
        real(kind=8) :: rt0
        real(kind=8) :: ept0
        integer :: erreur
        real(kind=8) :: xwns
        integer :: mfr
        real(kind=8) :: pw0
        real(kind=8) :: dpw
        real(kind=8) :: vw1
    end subroutine b3d_pm
end interface 
