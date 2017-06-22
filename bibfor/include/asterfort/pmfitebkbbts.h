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
    subroutine pmfitebkbbts(typfib, nf, ncarf, vf, ve, b, wi, gxjx, gxjxpou, g, gg, &
                            nbassepou, maxfipoutre, nbfipoutre, vev, yj, zj, vfv, skp, &
                            sk, vv, vvp)


        integer :: typfib
        integer :: nf
        integer :: ncarf
        real(kind=8) :: vf(ncarf, nf)
        real(kind=8) :: ve(nf)
        real(kind=8) :: b(4)
        real(kind=8) :: wi
        real(kind=8) :: gxjx
        real(kind=8) :: gxjxpou(*)
        real(kind=8) :: g
        real(kind=8) :: gg
        integer :: nbassepou
        integer :: maxfipoutre
        integer :: nbfipoutre(*)
        real(kind=8) :: vev(*)
        real(kind=8) :: yj(*)
        real(kind=8) :: zj(*)
        real(kind=8) :: vfv(7,*)
        real(kind=8) :: skp(78,*)
        real(kind=8) :: sk(78)
        real(kind=8) :: vv(12)
        real(kind=8) :: vvp(12,*)
    end subroutine pmfitebkbbts
end interface
