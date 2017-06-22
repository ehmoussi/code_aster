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
    subroutine exiscp(nomcmp, char, modele, nbnd, typend,&
                      nomnd, numnd, resu)
        character(len=8) :: nomcmp
        character(len=8) :: char
        character(len=8) :: modele
        integer :: nbnd
        character(len=3) :: typend
        character(len=8) :: nomnd(*)
        integer :: numnd(*)
        integer :: resu(*)
    end subroutine exiscp
end interface
