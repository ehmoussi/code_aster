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
    subroutine nmedco(compor, option, imate, npg, lgpg,&
                      s, q, vim, vip, alphap,&
                      dalfs)
        integer :: lgpg
        integer :: npg
        character(len=16) :: compor(*)
        character(len=16) :: option
        integer :: imate
        real(kind=8) :: s(2)
        real(kind=8) :: q(2, 2)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: alphap(2)
        real(kind=8) :: dalfs(2, 2)
    end subroutine nmedco
end interface
