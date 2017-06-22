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

subroutine cvrmzm(n, a, lda, b, ldb)
    implicit none
    integer :: n, lda, ldb
    real(kind=8) :: a(lda, *)
    complex(kind=8) :: b(ldb, *)
!   COPIE UNE MATRICE REELLE DANS UNE MATRICE COMPLEXE.
!-----------------------------------------------------------------------
! IN  : N    : DIMENSION DES MATRICES A ET B.
!     : A    : MATRICE REELLE DE DIMENSION N.
!     : LDA  : DIMENSION DE A.
!     : LDB  : DIMENSION DE B.
! OUT : B    : MATRICE COMPLEXE D'ORDRE N CONTENANT UNE COPIE DE A.
!-----------------------------------------------------------------------
    integer :: i, j
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (n .lt. 1) then
        write(6,*)  'THE ORDER OF THE MATRIX MUST BE AT '//&
     &               'LEAST 1 WHILE N = %(I1) IS GIVEN.'
        goto 9000
    endif
!
    if (lda .lt. n) then
        write(6,*)  'THE LEADING DIMENSION OF A MUST BE AT '//&
     &               'LEAST AS LARGE AS N WHILE LDA = %(I1) AND N '//&
     &               '= %(I2) ARE GIVEN.'
        goto 9000
    endif
!
    if (ldb .lt. n) then
        write(6,*)  'THE LEADING DIMENSION OF B MUST BE AT '//&
     &               'LEAST AS LARGE AS N WHILE LDB = %(I1) AND N '//&
     &               '= %(I2) ARE GIVEN.'
        goto 9000
    endif
!       --- A EST COPIEE DANS B
    do 10 j = n, 1, -1
        do 10 i = n, 1, -1
            b(i,j) = dcmplx(a(i,j),0.0d0)
10      continue
!
9000  continue
end subroutine
