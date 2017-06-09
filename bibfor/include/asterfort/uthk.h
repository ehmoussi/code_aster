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
    subroutine uthk(nomte, geom, hk, ndim, niv,&
                    noe, nsomm, tymvol, ifa)
        integer, parameter :: l1=9, l2=6, l3=4
        character(len=16), intent(in) :: nomte
        real(kind=8), intent(in) :: geom(*)
        real(kind=8), intent(out) :: hk
        integer, intent(in) :: ndim
        integer, intent(in) :: niv
        integer, intent(in), optional :: noe(l1*l2*l3)
        integer, intent(in), optional :: nsomm
        integer, intent(in), optional :: tymvol
        integer, intent(in), optional :: ifa
    end subroutine uthk
end interface
