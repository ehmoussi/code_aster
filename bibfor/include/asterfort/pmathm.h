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
    subroutine pmathm(dimmat, dimdef, dimcon, dimuel, dsde,&
                      drds, ck, b, poids, matri)
        integer :: dimuel
        integer :: dimcon
        integer :: dimdef
        integer :: dimmat
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: drds(dimdef, dimcon)
        real(kind=8) :: ck(dimdef)
        real(kind=8) :: b(dimdef, dimuel)
        real(kind=8) :: poids
        real(kind=8) :: matri(dimmat, dimmat)
    end subroutine pmathm
end interface
