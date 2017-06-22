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
    subroutine nmedsq(sg, qg, dsdug, d, npg,&
                      typmod, imate, bum, bdu, sign,&
                      vim, option, geom, nno, lgpg,&
                      kpg, def)
        integer :: lgpg
        integer :: nno
        integer :: npg
        real(kind=8) :: sg(2)
        real(kind=8) :: qg(2, *)
        real(kind=8) :: dsdug(2, 8)
        real(kind=8) :: d(4, *)
        character(len=8) :: typmod(*)
        integer :: imate
        real(kind=8) :: bum(6)
        real(kind=8) :: bdu(6)
        real(kind=8) :: sign(*)
        real(kind=8) :: vim(lgpg, npg)
        character(len=16) :: option
        real(kind=8) :: geom(2, nno)
        integer :: kpg
        real(kind=8) :: def(4, nno, 2)
    end subroutine nmedsq
end interface
