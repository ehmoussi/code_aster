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
    subroutine b3d_sigd(bg1, pg1, bw1, pw1, sfld,&
                        ssg6, e1, rt2, ept1, mfr,&
                        erreur, dg3, dw3, xnu0, sigaf6,&
                        dflu0, sigef6, xmg, sigat6, vplg33,&
                        vplg33t, vssw33, vssw33t, ssw6, dth0)
        real(kind=8) :: bg1
        real(kind=8) :: pg1
        real(kind=8) :: bw1
        real(kind=8) :: pw1
        real(kind=8) :: sfld
        real(kind=8) :: ssg6(6)
        real(kind=8) :: e1
        real(kind=8) :: rt2
        real(kind=8) :: ept1
        integer :: mfr
        integer :: erreur
        real(kind=8) :: dg3(3)
        real(kind=8) :: dw3(3)
        real(kind=8) :: xnu0
        real(kind=8) :: sigaf6(6)
        real(kind=8) :: dflu0
        real(kind=8) :: sigef6(6)
        real(kind=8) :: xmg
        real(kind=8) :: sigat6(6)
        real(kind=8) :: vplg33(3, 3)
        real(kind=8) :: vplg33t(3, 3)
        real(kind=8) :: vssw33(3, 3)
        real(kind=8) :: vssw33t(3, 3)
        real(kind=8) :: ssw6(6)
        real(kind=8) :: dth0
    end subroutine b3d_sigd
end interface 
