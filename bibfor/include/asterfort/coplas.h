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
    subroutine coplas(tempa, k1a, k1b, k1c, matrev, &
                      lrev, deklag, prodef, oridef, profil, &
                      kal, kbl, kcl, dkma, dkmb, &
                      dkmc, k1acp, k1bcp, k1ccp)
        real(kind=8) :: tempa
        real(kind=8) :: k1a
        real(kind=8) :: k1b
        real(kind=8) :: k1c
        character(len=8) :: matrev
        real(kind=8) :: lrev
        real(kind=8) :: deklag
        real(kind=8) :: prodef
        character(len=8) :: oridef
        character(len=12) :: profil
        real(kind=8) :: kal
        real(kind=8) :: kbl
        real(kind=8) :: kcl
        real(kind=8) :: dkma
        real(kind=8) :: dkmb
        real(kind=8) :: dkmc
        real(kind=8) :: k1acp
        real(kind=8) :: k1bcp
        real(kind=8) :: k1ccp
    end subroutine coplas
end interface
