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
! aslint: disable=W1504
#include "asterf_types.h"
!
interface
    subroutine mmmtmc(phase , l_pena_cont, l_pena_fric,&
                      ndim  , nnl        , nnm        ,&
                      norm  , tau1       , tau2       , mprojt,&
                      wpg   , ffl        , ffm        , jacobi,&
                      coefff, coefaf     ,&
                      dlagrf, djeut      ,&
                      rese  , nrese      , matrmc)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: l_pena_cont, l_pena_fric
        integer, intent(in) :: ndim, nnm, nnl
        real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
        real(kind=8), intent(in) :: wpg, ffl(9), ffm(9), jacobi
        real(kind=8), intent(in) :: coefff, coefaf
        real(kind=8), intent(in) :: dlagrf(2), djeut(3)
        real(kind=8), intent(in) :: rese(3), nrese
        real(kind=8), intent(out) :: matrmc(27, 9)
    end subroutine mmmtmc
end interface
