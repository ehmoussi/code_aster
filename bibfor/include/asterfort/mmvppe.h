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
#include "asterf_types.h"
!
interface
    subroutine mmvppe(typmae, typmam, iresog, ndim, nne,&
                      nnm, nnl, nbdm, laxis, ldyna,&
                      lpenac, jeusup, ffe, ffm, ffl,&
                      norm, tau1, tau2, mprojt, jacobi,&
                      wpg, dlagrc, dlagrf, jeu, djeu,&
                      djeut, l_previous)
        character(len=8) :: typmae
        character(len=8) :: typmam
        integer :: iresog
        integer :: ndim
        integer :: nne
        integer :: nnm
        integer :: nnl
        integer :: nbdm
        aster_logical :: laxis
        aster_logical :: ldyna
        aster_logical :: l_previous
        aster_logical :: lpenac
        real(kind=8) :: jeusup
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: ffl(9)
        real(kind=8) :: norm(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8) :: jacobi
        real(kind=8) :: wpg
        real(kind=8) :: dlagrc
        real(kind=8) :: dlagrf(2)
        real(kind=8) :: jeu
        real(kind=8) :: djeu(3)
        real(kind=8) :: djeut(3)
    end subroutine mmvppe
end interface
