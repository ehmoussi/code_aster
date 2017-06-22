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
    subroutine vdesga(kwgt, nb1, nb2, depl, btild,&
                      indith, alpha, tempga, epsiln, sigma,&
                      vectt)
        integer :: kwgt
        integer :: nb1
        integer :: nb2
        real(kind=8) :: depl(*)
        real(kind=8) :: btild(5, 42)
        integer :: indith
        real(kind=8) :: alpha
        real(kind=8) :: tempga(*)
        real(kind=8) :: epsiln(6, *)
        real(kind=8) :: sigma(6, *)
        real(kind=8) :: vectt(3, 3)
    end subroutine vdesga
end interface
