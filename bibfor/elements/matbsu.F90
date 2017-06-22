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

subroutine matbsu(nb1, xr, npgsr, intsn, b1mnc,&
                  b2mnc, b1mni, b2mni, b1mri, b2mri,&
                  b1src, b2src, b1su, b2su)
!
    implicit none
!
#include "asterfort/r8inir.h"
    integer :: nb1
!
    integer :: intsn
    integer :: npgsr
!
    integer :: i, j, k, l
    integer :: i1
!
    real(kind=8) :: xr ( * )
!
    real(kind=8) :: b1su ( 5 , 51 )
    real(kind=8) :: b2su ( 5 , 51 )
!
    real(kind=8) :: b1mnc ( 3 , 51 )
    real(kind=8) :: b2mnc ( 3 , 51 )
!
    real(kind=8) :: b1mni ( 3 , 51 )
    real(kind=8) :: b2mni ( 3 , 51 )
!
    real(kind=8) :: b1mri ( 3 , 51 , 4 )
    real(kind=8) :: b2mri ( 3 , 51 , 4 )
!
!
    real(kind=8) :: b1src ( 2 , 51 , 4 )
    real(kind=8) :: b2src ( 2 , 51 , 4 )
!
!
!DEB
!
!---- INITIALISATION
!
    call r8inir(5 * 51, 0.d0, b1su, 1)
!
    call r8inir(5 * 51, 0.d0, b2su, 1)
!
!---- ADRESSES POUR EXTRAPOLATION DES B
!
    l = 702
!
    i1 = l + 4 * ( intsn - 1 )
!
!---- REMPLISSAGE
!
    do 100 j = 1, 6 * nb1 + 3
        do 110 i = 1, 3
!
!---------- OPERATEURS DE FLEXION
!
            b1su ( i , j ) = b1mnc ( i , j ) - b1mni ( i , j )
            b2su ( i , j ) = b2mnc ( i , j ) - b2mni ( i , j )
!
!---------- EXTRAPOLATION
!
            do 120 k = 1, npgsr
!
!---------- OPERATEURS DE MEMBRANE
!
                b1su ( i , j ) = b1su ( i , j ) + xr ( i1 + k ) *&
                b1mri ( i , j , k )
!
                b2su ( i , j ) = b2su ( i , j ) + xr ( i1 + k ) *&
                b2mri ( i , j , k )
!
                if (i .le. 2) then
!
!------------------- OPERATEURS DE SHEAR
!
                    b1su ( i + 3 , j ) = b1su ( i + 3 , j ) + xr ( i1&
                    + k ) * b1src ( i , j , k )
!
                    b2su ( i + 3 , j ) = b2su ( i + 3 , j ) + xr ( i1&
                    + k ) * b2src ( i , j , k )
!
                endif
!
120          continue
110      continue
100  end do
!
!
!
!
!FIN
!
end subroutine
