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
    subroutine xmmaa0(ndim, nnc, jnne, hpg,&
                      ffc, jacobi, coefcr,&
                      coefcp, lpenac, jddle,&
                      nfhe, lmulti, heavno, mmat)
        integer :: ndim
        integer :: nnc
        integer :: jnne(3)
        real(kind=8) :: hpg
        real(kind=8) :: ffc(8)
        real(kind=8) :: jacobi
        real(kind=8) :: coefcr
        real(kind=8) :: coefcp
        aster_logical :: lpenac
        integer :: jddle(2)
        integer :: nfhe
        aster_logical :: lmulti
        integer :: heavno(8)
        real(kind=8) :: mmat(336, 336)
    end subroutine xmmaa0
end interface
