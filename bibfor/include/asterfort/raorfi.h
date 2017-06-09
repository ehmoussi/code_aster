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
    subroutine raorfi(noma, ligrel, noepou, cara, coorig,&
                      eg1, eg2, eg3, typrac, rayon)
        character(len=8) :: noma
        character(len=19) :: ligrel
        character(len=8) :: noepou
        character(len=8) :: cara
        real(kind=8) :: coorig(3)
        real(kind=8) :: eg1(3)
        real(kind=8) :: eg2(3)
        real(kind=8) :: eg3(3)
        character(len=8) :: typrac
        real(kind=8) :: rayon
    end subroutine raorfi
end interface
