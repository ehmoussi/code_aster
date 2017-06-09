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
    subroutine nmfi2d(npg, lgpg, mate, option, geom,&
                      deplm, ddepl, sigmo, sigma, fint,&
                      ktan, vim, vip, tm, tp,&
                      crit, compor, typmod, codret)
        integer :: lgpg
        integer :: npg
        integer :: mate
        character(len=16) :: option
        real(kind=8) :: geom(2, 4)
        real(kind=8) :: deplm(8)
        real(kind=8) :: ddepl(8)
        real(kind=8) :: sigmo(6, npg)
        real(kind=8) :: sigma(6, npg)
        real(kind=8) :: fint(8)
        real(kind=8) :: ktan(8, 8)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: tm
        real(kind=8) :: tp
        real(kind=8) :: crit(*)
        character(len=16) :: compor(*)
        character(len=8) :: typmod(*)
        integer :: codret
    end subroutine nmfi2d
end interface
