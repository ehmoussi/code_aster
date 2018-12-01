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
#include "asterf_types.h"
!
interface
    subroutine mmtgeo(phase,  l_large_slip,&
                      ndim  , nne   , nnm   ,&
                      wpg   , ffe   , ffm   , dffm  , ddffm ,&
                      jacobi, coefac, coefff, jeu   , dlagrc,&
                      mprojn,&
                      mprt1n, mprt2n, mprnt1, mprnt2,&
                      kappa , vech1 , vech2 , h     , hah   ,&
                      mprt11, mprt12, mprt21, mprt22,&
                      matree, matrmm, matrem, matrme)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: l_large_slip
        integer, intent(in) :: ndim, nne, nnm
        real(kind=8), intent(in) :: wpg, ffe(9), ffm(9), dffm(2,9), ddffm(3,9)
        real(kind=8), intent(in) :: jacobi, coefac, coefff, jeu, dlagrc
        real(kind=8), intent(in) :: mprojn(3,3)
        real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
        real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2), hah(2,2)
        real(kind=8), intent(in) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
        real(kind=8), intent(inout) :: matrem(27,27), matrme(27,27)
        real(kind=8), intent(inout) :: matree(27,27), matrmm(27,27)
    end subroutine mmtgeo
end interface
