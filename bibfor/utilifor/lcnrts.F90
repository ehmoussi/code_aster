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

function lcnrts(d)
    implicit none
!       'NORME' D UN DEVIATEUR AU SENS DU SECOND INVARIANT
!       DU TENSEUR (3X3) CORRESPONDANT SOUS FORME VECTEUR (6X1)
!       IN  D      :  DEVIATEUR
!                                           T  1/2
!       OUT LCNRTS :  NORME DE    D = (3/2 D D)
!       ----------------------------------------------------------------
#include "asterfort/lcprsc.h"
    integer :: n, nd
    real(kind=8) :: d(6), p, lcnrts
    common /tdim/   n , nd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call lcprsc(d, d, p)
    lcnrts = sqrt ( 1.5d0 * p )
end function
