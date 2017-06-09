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

subroutine matbsr(nb1, vectt, dudxrc, intsr, jdn1rc,&
                  jdn2rc, b1src, b2src)
!
    implicit none
!
#include "asterfort/hsash.h"
#include "asterfort/promat.h"
#include "asterfort/r8inir.h"
    integer :: i, j
!
    integer :: nb1
!
    integer :: intsr
!
    real(kind=8) :: vectt ( 3 , 3 )
!
    real(kind=8) :: dudxrc ( 9 )
!
    real(kind=8) :: jdn1rc ( 9 , 51 )
    real(kind=8) :: jdn2rc ( 9 , 51 )
!
    real(kind=8) :: b1src ( 2 , 51 , 4 )
    real(kind=8) :: b2src ( 2 , 51 , 4 )
!
    real(kind=8) :: tmp ( 2 , 51 )
!
    real(kind=8) :: hss1 ( 2 , 9 )
!
    real(kind=8) :: hss2 ( 2 , 9 )
!
!DEB
!
    call hsash(vectt, dudxrc, hss1, hss2)
!
!
! --- POUR LA DEFORMATION TOTALE   B1SRC
!
!---- INITIALISATION
!
    call r8inir(2 * 51, 0.d0, tmp, 1)
!
    call promat(hss1, 2, 2, 9, jdn1rc,&
                9, 9, 6 * nb1 + 3, tmp)
!
!
    do 100 j = 1, 6 * nb1 + 3
        do 110 i = 1, 2
!
            b1src ( i , j , intsr ) = tmp ( i , j )
!
110      continue
100  end do
!
!
!---- POUR LA DEFORMATION DIFFERENTIELLE   B2SRC
!
!---- INITIALISATION
!
    call r8inir(2 * 51, 0.d0, tmp, 1)
!
!
!
!
    call promat(hss2, 2, 2, 9, jdn2rc,&
                9, 9, 6 * nb1 + 3, tmp)
!
!
    do 200 j = 1, 6 * nb1 + 3
        do 210 i = 1, 2
!
            b2src ( i , j , intsr ) = tmp ( i , j )
!
210      continue
200  end do
!
!
!FIN
!
end subroutine
