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

subroutine dvout(lout, n, sx, idigit, ifmt)
!
!     SUBROUTINE ARPACK ECRIVANT DES VECTEURS DE REELS.
!-----------------------------------------------------------------------
!  PURPOSE:    REAL VECTOR OUTPUT ROUTINE.
!
!  USAGE:      CALL DVOUT (LOUT, N, SX, IDIGIT, IFMT)
!
!  ARGUMENTS
!     N      - LENGTH OF ARRAY SX.  (INPUT)
!     SX     - REAL ARRAY TO BE PRINTED.  (INPUT)
!     IFMT   - FORMAT TO BE USED IN PRINTING ARRAY SX.  (INPUT)
!     IDIGIT - PRINT UP TO IABS(IDIGIT) DECIMAL DIGITS PER NUMBER.  (IN)
!              IF IDIGIT .LT. 0, PRINTING IS DONE WITH 72 COLUMNS.
!              IF IDIGIT .GT. 0, PRINTING IS DONE WITH 132 COLUMNS.
!
!  INTRINSIC FUNCTIONS
!     LEN, MIN.
!-----------------------------------------------------------------------
!
! ASTER INFORMATION
! 14/01/2000 TOILETTAGE DU FORTRAN SUIVANT LES REGLES ASTER,
!            REMPLACEMENT DE RETURN PAR GOTO 1000,
!            IMPLICIT NONE.
! ENDLIB
!-----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
!     .. SCALAR ARGUMENTS ..
    character(len=*) :: ifmt
    integer :: idigit, lout, n
!
!     .. ARRAY ARGUMENTS ..
    real(kind=8) :: sx( * )
!
!     .. LOCAL SCALARS ..
    character(len=80) :: line
    integer :: i, k1, k2, lll, ndigit
!
!     .. EXECUTABLE STATEMENTS ..
!
!     ... FIRST EXECUTABLE STATEMENT
!
    lll = min( len( ifmt ), 80 )
    do 10 i = 1, lll
        line( i: i ) = '-'
10  end do
!
    do 20 i = lll + 1, 80
        line( i: i ) = ' '
20  end do
!
    write( lout, fmt = 9999 )ifmt, line( 1: lll )
    9999 format( / 1x, a, / 1x, a )
!
    if (n .le. 0) goto 1000
    ndigit = idigit
    if (idigit .eq. 0) ndigit = 4
!
!=======================================================================
!             CODE FOR OUTPUT USING 72 COLUMNS FORMAT
!=======================================================================
!
    if (idigit .lt. 0) then
        ndigit = -idigit
        if (ndigit .le. 4) then
            do 30 k1 = 1, n, 5
                k2 = min( n, k1+4 )
                write( lout, fmt = 9998 )k1, k2, ( sx( i ), i = k1,&
                k2 )
30          continue
        else if (ndigit.le.6) then
            do 40 k1 = 1, n, 4
                k2 = min( n, k1+3 )
                write( lout, fmt = 9997 )k1, k2, ( sx( i ), i = k1,&
                k2 )
40          continue
        else if (ndigit.le.10) then
            do 50 k1 = 1, n, 3
                k2 = min( n, k1+2 )
                write( lout, fmt = 9996 )k1, k2, ( sx( i ), i = k1,&
                k2 )
50          continue
        else
            do 60 k1 = 1, n, 2
                k2 = min( n, k1+1 )
                write( lout, fmt = 9995 )k1, k2, ( sx( i ), i = k1,&
                k2 )
60          continue
        endif
!
!=======================================================================
!             CODE FOR OUTPUT USING 132 COLUMNS FORMAT
!=======================================================================
!
    else
        if (ndigit .le. 4) then
            do 70 k1 = 1, n, 10
                k2 = min( n, k1+9 )
                write( lout, fmt = 9998 )k1, k2, ( sx( i ), i = k1,&
                k2 )
70          continue
        else if (ndigit.le.6) then
            do 80 k1 = 1, n, 8
                k2 = min( n, k1+7 )
                write( lout, fmt = 9997 )k1, k2, ( sx( i ), i = k1,&
                k2 )
80          continue
        else if (ndigit.le.10) then
            do 90 k1 = 1, n, 6
                k2 = min( n, k1+5 )
                write( lout, fmt = 9996 )k1, k2, ( sx( i ), i = k1,&
                k2 )
90          continue
        else
            do 100 k1 = 1, n, 5
                k2 = min( n, k1+4 )
                write( lout, fmt = 9995 )k1, k2, ( sx( i ), i = k1,&
                k2 )
100          continue
        endif
    endif
    write( lout, fmt = 9994 )
    9998 format( 1x, i4, ' - ', i4, ':', 1p, 10d12.3 )
    9997 format( 1x, i4, ' - ', i4, ':', 1x, 1p, 8d14.5 )
    9996 format( 1x, i4, ' - ', i4, ':', 1x, 1p, 6d18.9 )
    9995 format( 1x, i4, ' - ', i4, ':', 1x, 1p, 5d24.13 )
    9994 format( 1x, ' ' )
!
1000  continue
end subroutine
