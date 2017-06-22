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
    subroutine cgnoor(mafour, nomail, motfac, iocc, nbmc,&
                      motcle, typmcl, typlig, nbma, ndorig,&
                      ndextr, typm, vecori)
        character(len=24) :: mafour
        character(len=8) :: nomail
        character(len=*) :: motfac
        integer :: iocc
        integer :: nbmc
        character(len=16) :: motcle(*)
        character(len=16) :: typmcl(*)
        character(len=*) :: typlig
        integer :: nbma
        character(len=8) :: ndorig
        character(len=8) :: ndextr
        character(len=8) :: typm
        real(kind=8) :: vecori(3)
    end subroutine cgnoor
end interface
