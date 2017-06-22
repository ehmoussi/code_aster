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
    subroutine accept(f, nbm, method, imode, jmode,&
                      uflui, jc, dir, uc, uct,&
                      l, lt)
        real(kind=8) :: f
        integer :: nbm
        character(len=8) :: method
        integer :: imode
        integer :: jmode
        real(kind=8) :: uflui
        real(kind=8) :: jc
        real(kind=8) :: dir(3, 3)
        real(kind=8) :: uc
        real(kind=8) :: uct
        real(kind=8) :: l
        real(kind=8) :: lt
    end subroutine accept
end interface
