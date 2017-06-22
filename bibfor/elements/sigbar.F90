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

subroutine sigbar(sigma, barsig)
!
    implicit none
!
! ......................................................................
!     FONCTION  :  CALCUL DE
!
!                         (   SIGMA  0       0     )
!      BARS   ( 9 , 9 ) = (   0      SIGMA   0     )
!                         (   0      0       SIGMA )
!
!      AVEC
!
!      SIGMA  ( 3 , 3 )
!
!                  POUR LA PARTIE GEOMETRIQUE DE LA MATRICE TANGENTE
!                  COQUE_3D
!
! ......................................................................
!
#include "asterfort/r8inir.h"
    integer :: i
!
    integer :: ii, jj
!
    real(kind=8) :: sigma ( 3 , 3 )
!
    real(kind=8) :: barsig ( 9 , 9 )
!
! DEB
!
    call r8inir(9 * 9, 0.d0, barsig, 1)
!
    do 200 i = 1, 3
        do 210 jj = 1, 3
            do 220 ii = 1, 3
                barsig ( ( i - 1 ) * 3 + ii , ( i - 1 ) * 3 + jj ) =&
                sigma ( ii , jj )
220          continue
210      continue
200  continue
!
! FIN
!
end subroutine
