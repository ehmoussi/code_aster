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
    subroutine ircmec(idfimd, nochmd, nomprf, nolopg, numpt,&
                      instan, numord, val, ncmpve, nbenty,&
                      nbrepg, nvalec, typent, typgeo, codret)
        integer :: idfimd
        character(len=*) :: nochmd
        character(len=*) :: nomprf
        character(len=*) :: nolopg
        integer :: numpt
        real(kind=8) :: instan
        integer :: numord
        real(kind=8) :: val(*)
        integer :: ncmpve
        integer :: nbenty
        integer :: nbrepg
        integer :: nvalec
        integer :: typent
        integer :: typgeo
        integer :: codret
    end subroutine ircmec
end interface
