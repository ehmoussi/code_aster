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
    subroutine xmmab2(ndim, jnne, ndeple, nnc, jnnm,&
                      hpg, ffc, ffe,&
                      ffm, jacobi, lambda, coefcr,&
                      coeffr, jeu, coeffp,&
                      lpenaf, coefff, tau1, tau2, rese,&
                      nrese, mproj, norm, nsinge,&
                      nsingm, fk_escl, fk_mait, nvit, nconta,&
                      jddle, jddlm, nfhe, nfhm, heavn, mmat)
        integer :: ndim
        integer :: jnne(3)
        integer :: ndeple
        integer :: nnc
        integer :: jnnm(3)
        real(kind=8) :: hpg
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffe(20)
        real(kind=8) :: ffm(20)
        real(kind=8) :: jacobi
        real(kind=8) :: lambda
        real(kind=8) :: coefcr
        real(kind=8) :: coeffr
        real(kind=8) :: jeu
        real(kind=8) :: coeffp
        aster_logical :: lpenaf
        real(kind=8) :: coefff
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: rese(3)
        real(kind=8) :: nrese
        real(kind=8) :: mproj(3, 3)
        real(kind=8) :: norm(3)
        integer :: nsinge
        integer :: nsingm
        real(kind=8) :: fk_escl(27,3,3)
        real(kind=8) :: fk_mait(27,3,3)
        integer :: nvit
        integer :: nconta
        integer :: jddle(2)
        integer :: jddlm(2)
        integer :: nfhe
        integer :: nfhm
        integer :: heavn(*)
        real(kind=8) :: mmat(336, 336)
    end subroutine xmmab2
end interface
