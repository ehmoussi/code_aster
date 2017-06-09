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

subroutine lcgrla(f, eps)
    implicit none
!
!
!     DEFORMATION DE GREEN-LAGRANGE ASSOCIEE AU TENSEUR F
!     ----------------------------------------------------------------
!
#include "asterfort/lctr2m.h"
#include "asterfort/pmat.h"
#include "asterfort/tnsvec.h"
#include "blas/daxpy.h"
#include "blas/dscal.h"
    real(kind=8) :: f(3, 3), ft(3, 3), ftf(3, 3), eps(6), id6(6)
    data id6/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
!
    call lctr2m(3, f, ft)
    call pmat(3, ft, f, ftf)
    call tnsvec(3, 3, ftf, eps, 1.d0)
    call daxpy(6, -1.d0, id6, 1, eps,&
               1)
    call dscal(6, 0.5d0, eps, 1)
!
end subroutine
