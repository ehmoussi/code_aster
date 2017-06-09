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

subroutine matsa(dudx, sa1, sa2)
!
!
!---- MATRICES
!      SA1 ( 6 , 9 ) =  S  + 1 / 2  A ( DUDX )  DEF TOT
!      SA2 ( 6 , 9 ) =  S  +        A ( DUDX )  DEF DIF
!
!
    implicit none
!
#include "asterfort/r8inir.h"
    integer :: i, j
!
    real(kind=8) :: dudx ( 9 )
!
    real(kind=8) :: s ( 6 , 9 )
    real(kind=8) :: a ( 6 , 9 )
!
    real(kind=8) :: sa1 ( 6 , 9 )
!
    real(kind=8) :: sa2 ( 6 , 9 )
!
!DEB
!
!---- INITIALISATION
!
    call r8inir(6 * 9, 0.d0, s, 1)
!
    call r8inir(6 * 9, 0.d0, a, 1)
!
!---- CONSTRUCTION DE  S    ( 6 , 9 )
!
!---- LIGNES 1 2 3
!
    s ( 1 , 1 )  = 1.d0
    s ( 2 , 5 )  = 1.d0
    s ( 3 , 9 )  = 1.d0
!
!---- LIGNES 4 5 6
!
    s ( 4 , 2 )  = 1.d0
    s ( 4 , 4 )  = 1.d0
!
    s ( 5 , 3 )  = 1.d0
    s ( 5 , 7 )  = 1.d0
!
    s ( 6 , 6 )  = 1.d0
    s ( 6 , 8 )  = 1.d0
!
!---- INITIALISATION
!
    call r8inir(6 * 9, 0.d0, a, 1)
!
!---- CONSTRUCTION DE  A    ( 6 , 9 )
!
!---- LIGNE 1
!
    a ( 1 , 1 )  = dudx ( 1 )
    a ( 1 , 4 )  = dudx ( 4 )
    a ( 1 , 7 )  = dudx ( 7 )
!
!---- LIGNE 2
!
    a ( 2 , 2 )  = dudx ( 2 )
    a ( 2 , 5 )  = dudx ( 5 )
    a ( 2 , 8 )  = dudx ( 8 )
!
!---- LIGNE 3
!
    a ( 3 , 3 )  = dudx ( 3 )
    a ( 3 , 6 )  = dudx ( 6 )
    a ( 3 , 9 )  = dudx ( 9 )
!
!---- LIGNE 4
!
    a ( 4 , 1 )  = dudx ( 2 )
    a ( 4 , 2 )  = dudx ( 1 )
!
    a ( 4 , 4 )  = dudx ( 5 )
    a ( 4 , 5 )  = dudx ( 4 )
!
    a ( 4 , 7 )  = dudx ( 8 )
    a ( 4 , 8 )  = dudx ( 7 )
!
!---- LIGNE 5
!
    a ( 5 , 1 )  = dudx ( 3 )
!
    a ( 5 , 3 )  = dudx ( 1 )
    a ( 5 , 4 )  = dudx ( 6 )
!
    a ( 5 , 6 )  = dudx ( 4 )
    a ( 5 , 7 )  = dudx ( 9 )
!
    a ( 5 , 9 )  = dudx ( 7 )
!
!---- LIGNE 6
!
    a ( 6 , 2 )  = dudx ( 3 )
    a ( 6 , 3 )  = dudx ( 2 )
!
    a ( 6 , 5 )  = dudx ( 6 )
    a ( 6 , 6 )  = dudx ( 5 )
!
    a ( 6 , 8 )  = dudx ( 9 )
    a ( 6 , 9 )  = dudx ( 8 )
!
!
!
! --- POUR LA DEFORMATION TOTALE           S + 0.5 A
! --- POUR LA DEFORMATION DIFFERENTIELLE   S +     A
!
    do 100 j = 1, 9
        do 110 i = 1, 6
!
            sa1 ( i , j ) = s ( i , j ) + 0.5d0 * a ( i , j )
!
            sa2 ( i , j ) = s ( i , j ) + a ( i , j )
!
110      continue
100  end do
!
!FIN
!
end subroutine
