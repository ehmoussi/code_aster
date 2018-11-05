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
    subroutine mmgnem(ndim   ,nnm   , nne   ,&
                      wpg   , ffe   , dffm  ,&
                      jacobi, coefac, jeu   , dlagrc,&
                      mprt1n, mprt2n, &
                      kappa , vech1 , vech2 , h     ,&
                      matrem)
        integer, intent(in) :: ndim, nnm, nne
        real(kind=8), intent(in) :: wpg, ffe(9),dffm(2,9)
        real(kind=8), intent(in) :: jacobi, coefac, jeu, dlagrc
        real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3)
        real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2)
        real(kind=8), intent(inout) :: matrem(27, 27)
    end subroutine mmgnem
end interface
