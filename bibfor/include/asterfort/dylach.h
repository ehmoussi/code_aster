! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine dylach(nomo, mate, mateco, carele, lischa, numedd,&
                      vediri, veneum, vevoch, vassec)
        character(len=8) :: nomo
        character(len=24) :: mate, mateco
        character(len=24) :: carele
        character(len=19) :: lischa
        character(len=*) :: numedd
        character(len=19) :: vediri
        character(len=19) :: veneum
        character(len=19) :: vevoch
        character(len=19) :: vassec
    end subroutine dylach
end interface
