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
    subroutine pcfact(matas, nequ, in, ip, ac,&
                      prc, vect, epsi)
        integer :: nequ
        character(len=19) :: matas
        integer :: in(nequ)
        integer(kind=4) :: ip(*)
        real(kind=8) :: ac(*)
        real(kind=8) :: prc(*)
        real(kind=8) :: vect(nequ)
        real(kind=8) :: epsi
    end subroutine pcfact
end interface
