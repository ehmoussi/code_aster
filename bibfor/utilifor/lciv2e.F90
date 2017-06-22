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

function lciv2e(a)
    implicit none
!       SECOND INVARIANT TENSEUR DEFORMATION(3X3) SOUS FORME VECTEUR 6X1
!       IN  A      :   TENSEUR
!                                             T  1/2
!       OUT EQUIV  :  EQUIVALENT DE A = (2/3 D D)
!                     AVEC          D = A - 1/3 TR(A) I
!       ----------------------------------------------------------------
#include "asterfort/lcdevi.h"
#include "asterfort/lcnrte.h"
    integer :: n, nd
    real(kind=8) :: a(6), dev(6)
    real(kind=8) :: lciv2e
    common /tdim/   n , nd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call lcdevi(a, dev)
    lciv2e = lcnrte ( dev )
end function
