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

subroutine matbmr(nb1, vectt, dudxri, intsr, jdn1ri,&
                  b1mri, b2mri)
!
    implicit none
!
#include "asterfort/hsame.h"
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
    real(kind=8) :: dudxri ( 9 )
!
    real(kind=8) :: jdn1ri ( 9 , 51 )
!
    real(kind=8) :: b1mri ( 3 , 51 , 4 )
    real(kind=8) :: b2mri ( 3 , 51 , 4 )
!
    real(kind=8) :: tmp ( 3 , 51 )
!
    real(kind=8) :: hsm1 ( 3 , 9 )
!
    real(kind=8) :: hsm2 ( 3 , 9 )
!
!DEB
!
    call hsame(vectt, dudxri, hsm1, hsm2)
!
! --- POUR LA DEFORMATION TOTALE   B1MRI
!
    call promat(hsm1, 3, 3, 9, jdn1ri,&
                9, 9, 6 * nb1 + 3, tmp)
!
!
    do 100 j = 1, 6 * nb1 + 3
        do 110 i = 1, 3
!
            b1mri ( i , j , intsr ) = tmp ( i , j )
!
110      continue
100  end do
!
!
!---- POUR LA DEFORMATION DIFFERENTIELLE   B2MRI
!
!---- INITIALISATION
!
!
    call r8inir(3 * 51, 0.d0, tmp, 1)
!
!
!
!
    call promat(hsm2, 3, 3, 9, jdn1ri,&
                9, 9, 6 * nb1 + 3, tmp)
!
!
    do 200 j = 1, 6 * nb1 + 3
        do 210 i = 1, 3
!
            b2mri ( i , j , intsr ) = tmp ( i , j )
!
210      continue
200  end do
!
!
!FIN
!
end subroutine
