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
    subroutine mmmvuu(phase , l_pena_cont, l_pena_fric, l_large_slip,&
                      ndim  , nne   , nnm   ,&
                      norm  , tau1  , tau2  , mprojt,&
                      wpg   , ffe   , ffm   , dffm  , jacobi, jeu   ,&
                      coefac, coefaf, lambda, coefff,&
                      dlagrc, dlagrf, djeu  ,&
                      rese  , nrese ,&
                      mprt1n, mprt2n,&
                      mprt11, mprt12, mprt21, mprt22, kappa,&
                      vectee, vectmm)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: l_pena_cont, l_pena_fric, l_large_slip
        integer, intent(in) :: ndim, nne, nnm
        real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
        real(kind=8), intent(in) :: wpg, ffe(9), ffm(9), dffm(2,9), jacobi, jeu
        real(kind=8), intent(in) :: coefac, coefaf, lambda, coefff
        real(kind=8), intent(in) :: dlagrc, dlagrf(2), djeu(3)
        real(kind=8), intent(in) :: rese(3), nrese
        real(kind=8), intent(in) :: mprt1n(3, 3), mprt2n(3, 3)
        real(kind=8), intent(in) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
        real(kind=8), intent(in) :: kappa(2,2)
        real(kind=8), intent(out) :: vectee(27), vectmm(27)
    end subroutine mmmvuu
end interface
