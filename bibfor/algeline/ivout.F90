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

subroutine ivout(lout, n, ix, idigit, ifmt)
!
!     SUBROUTINE ARPACK ECRIVANT DES VECTEURS D'ENTIERS.
!-----------------------------------------------------------------------
!  ROUTINE:    IVOUT
!
!  PURPOSE:    INTEGER VECTOR OUTPUT ROUTINE.
!
!  ARGUMENTS
!     N      - LENGTH OF ARRAY IX. (INPUT)
!     IX     - INTEGER ARRAY TO BE PRINTED. (INPUT)
!     IFMT   - FORMAT TO BE USED IN PRINTING ARRAY IX. (INPUT)
!     IDIGIT - PRINT UP TO ABS(IDIGIT) DECIMAL DIGITS / NUMBER. (INPUT)
!              IF IDIGIT .LT. 0, PRINTING IS DONE WITH 72 COLUMNS.
!              IF IDIGIT .GT. 0, PRINTING IS DONE WITH 132 COLUMNS.
! INTRINSIC FUNCTIONS
!     MIN, LEN
!
!-----------------------------------------------------------------------
! ASTER INFORMATION
! 14/01/2000 TOILETTAGE DU FORTRAN SUIVANT LES REGLES ASTER.
!            REMPLACEMENT DE 1 RETURN PAR 1 GOTO 1005.
!            IMPLICIT NONE.
!-----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
!     ... SPECIFICATIONS FOR ARGUMENTS
    integer :: ix(*), n, idigit, lout
    character(len=*) :: ifmt
!
!     ... SPECIFICATIONS FOR LOCAL VARIABLES
    integer :: i, ndigit, k1, k2, lll
    character(len=80) :: line
!
    lll = min ( len ( ifmt ), 80 )
    do 1 i = 1, lll
        line(i:i) = '-'
 1  end do
!
    do 2 i = lll+1, 80
        line(i:i) = ' '
 2  end do
!
    write ( lout, 2000 ) ifmt, line(1:lll)
    2000 format ( /1x, a  /1x, a )
!
    if (n .le. 0) goto 1005
    ndigit = idigit
    if (idigit .eq. 0) ndigit = 4
!
!=======================================================================
!             CODE FOR OUTPUT USING 72 COLUMNS FORMAT
!=======================================================================
!
    if (idigit .lt. 0) then
!
        ndigit = -idigit
        if (ndigit .le. 4) then
            do 10 k1 = 1, n, 10
                k2 = min(n,k1+9)
                write(lout,1000) k1,k2,(ix(i),i=k1,k2)
10          continue
!
        else if (ndigit .le. 6) then
            do 30 k1 = 1, n, 7
                k2 = min(n,k1+6)
                write(lout,1001) k1,k2,(ix(i),i=k1,k2)
30          continue
!
        else if (ndigit .le. 10) then
            do 50 k1 = 1, n, 5
                k2 = min(n,k1+4)
                write(lout,1002) k1,k2,(ix(i),i=k1,k2)
50          continue
!
        else
            do 70 k1 = 1, n, 3
                k2 = min(n,k1+2)
                write(lout,1003) k1,k2,(ix(i),i=k1,k2)
70          continue
        endif
!
!=======================================================================
!             CODE FOR OUTPUT USING 132 COLUMNS FORMAT
!=======================================================================
!
    else
!
        if (ndigit .le. 4) then
            do 90 k1 = 1, n, 20
                k2 = min(n,k1+19)
                write(lout,1000) k1,k2,(ix(i),i=k1,k2)
90          continue
!
        else if (ndigit .le. 6) then
            do 110 k1 = 1, n, 15
                k2 = min(n,k1+14)
                write(lout,1001) k1,k2,(ix(i),i=k1,k2)
110          continue
!
        else if (ndigit .le. 10) then
            do 130 k1 = 1, n, 10
                k2 = min(n,k1+9)
                write(lout,1002) k1,k2,(ix(i),i=k1,k2)
130          continue
!
        else
            do 150 k1 = 1, n, 7
                k2 = min(n,k1+6)
                write(lout,1003) k1,k2,(ix(i),i=k1,k2)
150          continue
        endif
    endif
    write (lout,1004)
!
    1000 format(1x,i4,' - ',i4,':',20(1x,i5))
    1001 format(1x,i4,' - ',i4,':',15(1x,i7))
    1002 format(1x,i4,' - ',i4,':',10(1x,i11))
    1003 format(1x,i4,' - ',i4,':',7(1x,i15))
    1004 format(1x,' ')
!
1005  continue
end subroutine
