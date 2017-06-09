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
    subroutine rsorac(nomsd, acces, ival, rval, kval,&
                      cval, epsi, crit, nutrou, ndim,&
                      nbtrou)
        character(len=*), intent(in) :: nomsd
        character(len=*), intent(in) :: acces
        integer, intent(in) :: ival
        real(kind=8), intent(in) :: rval
        character(len=*), intent(in) :: kval
        complex(kind=8), intent(in) :: cval
        real(kind=8), intent(in) :: epsi
        character(len=*), intent(in) :: crit
        integer, intent(out) :: nutrou(*)
        integer, intent(in) :: ndim
        integer, intent(out) :: nbtrou
    end subroutine rsorac
end interface
