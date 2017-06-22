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
    subroutine pbflui(umoy, hmoy, rmoy, long, cf0,&
                      mcf0, fsvr, icoq, imod, nbm,&
                      rki, tcoef, s1, s2, ysol)
        integer :: nbm
        real(kind=8) :: umoy
        real(kind=8) :: hmoy
        real(kind=8) :: rmoy
        real(kind=8) :: long
        real(kind=8) :: cf0
        real(kind=8) :: mcf0
        real(kind=8) :: fsvr(7)
        integer :: icoq
        integer :: imod
        real(kind=8) :: rki
        real(kind=8) :: tcoef(10, nbm)
        real(kind=8) :: s1
        real(kind=8) :: s2
        complex(kind=8) :: ysol(3, 101)
    end subroutine pbflui
end interface
