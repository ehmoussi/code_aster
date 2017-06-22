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

subroutine lcdetf(ndim, fr, det)
!     BUT:  CALCUL DU DETERMINANT DU GRADIENT DE TRANSFORMATION FR
! ----------------------------------------------------------------------
! IN  NDIM    : DIMENSION DU PROBLEME : 2 OU 3
! IN  FR      : GRADIENT TRANSFORMATION
! OUT DETF    : DETERMINANT
!
    implicit none
#include "asterfort/assert.h"
    integer :: ndim
    real(kind=8) :: fr(3, 3), det
!
    if (ndim .eq. 3) then
        det = fr(1,1)*(fr(2,2)*fr(3,3)-fr(2,3)*fr(3,2)) - fr(2,1)*(fr( 1,2)*fr(3,3)-fr(1,3)*fr(3,&
              &2)) + fr(3,1)*(fr(1,2)*fr(2,3)-fr(1, 3)*fr(2,2))
    else if (ndim.eq.2) then
        det = fr(3,3)*(fr(1,1)*fr(2,2)-fr(1,2)*fr(2,1))
    else
        ASSERT(.false.)
    endif
!
end subroutine
