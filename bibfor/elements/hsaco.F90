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

subroutine hsaco(vectt, dudxnc, hsc)
!
    implicit none
!
#include "asterfort/hsame.h"
#include "asterfort/hsash.h"
    real(kind=8) :: vectt ( 3 , 3 )
!
    real(kind=8) :: dudxnc ( 9 )
!
    real(kind=8) :: hsm1 ( 3 , 9 )
!
    real(kind=8) :: hsm2 ( 3 , 9 )
!
    real(kind=8) :: hss1 ( 2 , 9 )
!
    real(kind=8) :: hss2 ( 2 , 9 )
!
    real(kind=8) :: hsc ( 5 , 9 )
!
    integer :: i, j
!
!DEB
!
!---- MEMBRANE  ( H ) * ( ( S ) + ( A ) )
!
    call hsame(vectt, dudxnc, hsm1, hsm2)
!
!---- SHEAR     ( H ) * ( ( S ) + ( A ) )
!
    call hsash(vectt, dudxnc, hss1, hss2)
!
!                                    (  HSM2 ( 3 , 9 )  )
!---- REMLISSAGE DE  HSC ( 5 , 9 ) = (------------------)
!                                    (  HSS2  ( 2 , 9 )  )
!
!                 HSC ( 5 , 9 ) = H ( 5 , 6 ) * S ( 6, 9 )
!
    do 100 j = 1, 9
!
        do 110 i = 1, 3
            hsc ( i , j ) = hsm2 ( i , j )
            if (i .le. 2) hsc ( i + 3 , j ) = hss2 ( i , j )
!
110      continue
!
100  end do
!
!
!
!FIN
!
end subroutine
