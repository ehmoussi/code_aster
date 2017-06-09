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

subroutine hsall(vectt, hstout)
!
!
! ......................................................................
!     FONCTION :  CALCUL DE LA MATRICE
!
!                 HSTOUT ( 5 , 9 ) = H ( 5 , 6 ) * S ( 6 , 9 )
!
!                 AU POINTS D INTEGRATION NORMALE
! ......................................................................
!
!
!
    implicit none
!
#include "asterfort/hfmss.h"
    integer :: i, j
!
    real(kind=8) :: vectt ( 3 , 3 )
!
    real(kind=8) :: hstout ( 5 , 9 )
!
    real(kind=8) :: hsfm ( 3 , 9 )
!
    real(kind=8) :: hss ( 2 , 9 )
!
!
!DEB
!
!---- CALCUL DE HSFM ( 3 , 9 ) ET HSS  ( 2 , 9 )
!
    call hfmss(1, vectt, hsfm, hss)
!
!
!                                       (  HSFM ( 3 , 9 )  )
!---- REMLISSAGE DE  HSTOUT ( 5 , 9 ) = (------------------)
!                                       (  HSS  ( 2 , 9 )  )
!
!
!                 HSTOUT ( 5 , 9 ) = H ( 5 , 6 ) * S ( 6, 9 )
!
!
!
    do 100 j = 1, 9
        do 110 i = 1, 3
            hstout ( i , j ) = hsfm ( i , j )
            if (i .le. 2) hstout ( i + 3 , j ) = hss ( i , j )
110      continue
100  end do
!
!
!FIN
!
end subroutine
