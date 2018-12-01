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
#include "asterf_types.h"
!
interface
    subroutine mmvape(phase , leltf , l_pena_cont, l_pena_fric,&
                      ndim  , nnl   , nbcps      ,&
                      ffl   ,&
                      wpg   , jacobi, jeu        , djeu, lambda,&
                      coefac, coefaf, coefff, &
                      tau1  , tau2  , mprojt, &
                      dlagrc, dlagrf, rese,&
                      vectcc, vectff)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: leltf, l_pena_cont, l_pena_fric
        integer, intent(in) :: ndim, nnl, nbcps
        real(kind=8), intent(in) :: ffl(9)
        real(kind=8), intent(in) :: coefac, coefaf, coefff
        real(kind=8), intent(in) :: wpg, jacobi, jeu, lambda
        real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
        real(kind=8), intent(in) :: dlagrc, dlagrf(2), djeu(3), rese(3)
        real(kind=8), intent(out) :: vectcc(9), vectff(18)
    end subroutine mmvape
end interface
