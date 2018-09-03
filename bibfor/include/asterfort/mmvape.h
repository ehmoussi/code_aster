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
!
#include "asterf_types.h"
!
interface
    subroutine mmvape(phasep, leltf, ndim, nnl, nbcps,&
                      coefac, coefaf, coefff, ffl, wpg,&
                      jeu, jacobi, lambda, tau1, tau2,&
                      mprojt, dlagrc, dlagrf, dvite, rese,&
                      vectcc, vectff)
        character(len=9) :: phasep
        aster_logical :: leltf
        integer :: ndim
        integer :: nnl
        integer :: nbcps
        real(kind=8) :: coefac
        real(kind=8) :: coefaf
        real(kind=8) :: coefff
        real(kind=8) :: ffl(9)
        real(kind=8) :: wpg
        real(kind=8) :: jeu
        real(kind=8) :: jacobi
        real(kind=8) :: lambda
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8) :: dlagrc
        real(kind=8) :: dlagrf(2)
        real(kind=8) :: dvite(3)
        real(kind=8) :: rese(3)
        real(kind=8) :: vectcc(9)
        real(kind=8) :: vectff(18)
    end subroutine mmvape
end interface
