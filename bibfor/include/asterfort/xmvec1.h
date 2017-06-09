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
#include "asterf_types.h"
!
interface
    subroutine xmvec1(ndim, jnne, ndeple, nnc, jnnm,&
                      hpg, ffc, ffe, ffm,&
                      jacobi, dlagrc, coefcr,&
                      coefcp, lpenac, jeu, norm,&
                      nsinge, nsingm, fk_escl, fk_mait,&
                      jddle, jddlm, nfhe, nfhm, lmulti,&
                      heavno, heavn, heavfa, vtmp)
        integer :: ndim
        integer :: jnne(3)
        integer :: ndeple
        integer :: nnc
        integer :: jnnm(3)
        real(kind=8) :: hpg
        real(kind=8) :: ffc(9)
        real(kind=8) :: ffe(20)
        real(kind=8) :: ffm(20)
        real(kind=8) :: jacobi
        real(kind=8) :: dlagrc
        real(kind=8) :: coefcr
        real(kind=8) :: coefcp
        aster_logical :: lpenac
        real(kind=8) :: jeu
        real(kind=8) :: norm(3)
        integer :: nsinge
        integer :: nsingm
        real(kind=8) :: fk_escl(27,3,3)
        real(kind=8) :: fk_mait(27,3,3)
        integer :: jddle(2)
        integer :: jddlm(2)
        integer :: nfhe
        integer :: nfhm
        aster_logical :: lmulti
        integer :: heavno(8)
        integer :: heavn(*)
        integer :: heavfa(*)
        real(kind=8) :: vtmp(336)
    end subroutine xmvec1
end interface
