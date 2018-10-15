! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mmgnee(ndim  , nne   , wpg   , ffe   ,&
                      jacobi, coefac, jeu   , dlagrc,&
                      kappa , vech1 , vech2 , h     , hah   ,&
                      mprt11, mprt12, mprt21, mprt22,&
                      matree)
        integer, intent(in) :: ndim, nne
        real(kind=8), intent(in) :: ffe(9)
        real(kind=8), intent(in) :: wpg, jacobi, coefac, jeu, dlagrc
        real(kind=8), intent(in) :: vech1(3), vech2(3), h(2,2), hah(2,2), kappa(2,2)
        real(kind=8), intent(in) :: mprt11(3, 3), mprt12(3,3), mprt21(3, 3), mprt22(3, 3)
        real(kind=8), intent(inout) :: matree(27, 27)
    end subroutine mmgnee
end interface
