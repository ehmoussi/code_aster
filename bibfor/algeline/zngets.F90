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

subroutine zngets(ishift, which, kev, np, ritz,&
                  bounds)
!
!     SUBROUTINE ARPACK CALCULANT NP SHIFTS DU RESTART DE IRAM.
!---------------------------------------------------------------------
!\BEGINDOC
!
!\NAME: ZNGETS
!
!\DESCRIPTION:
!  GIVEN THE EIGENVALUES OF THE UPPER HESSENBERG MATRIX H,
!  COMPUTES THE NP SHIFTS AMU THAT ARE ZEROS OF THE POLYNOMIAL OF
!  DEGREE NP WHICH FILTERS OUT COMPONENTS OF THE UNWANTED EIGENVECTORS
!  CORRESPONDING TO THE AMU'S BASED ON SOME GIVEN CRITERIA.
!
!  NOTE: CALL THIS EVEN IN THE CASE OF USER SPECIFIED SHIFTS IN ORDER
!  TO SORT THE EIGENVALUES, AND ERROR BOUNDS OF H FOR LATER USE.
!
!\USAGE:
!  CALL ZNGETS
!      ( ISHIFT, WHICH, KEV, NP, RITZ, BOUNDS )
!
!\ARGUMENTS
!  ISHIFT  INTEGER.  (INPUT)
!          METHOD FOR SELECTING THE IMPLICIT SHIFTS AT EACH ITERATION.
!          ISHIFT = 0: USER SPECIFIED SHIFTS
!          ISHIFT = 1: EXACT SHIFT WITH RESPECT TO THE MATRIX H.
!
!  WHICH   CHARACTER*2.  (INPUT)
!          SHIFT SELECTION CRITERIA.
!          'LM' -> WANT THE KEV EIGENVALUES OF LARGEST MAGNITUDE.
!          'SM' -> WANT THE KEV EIGENVALUES OF SMALLEST MAGNITUDE.
!          'LR' -> WANT THE KEV EIGENVALUES OF LARGEST REAL PART.
!          'SR' -> WANT THE KEV EIGENVALUES OF SMALLEST REAL PART.
!          'LI' -> WANT THE KEV EIGENVALUES OF LARGEST IMAGINARY PART.
!          'SI' -> WANT THE KEV EIGENVALUES OF SMALLEST IMAGINARY PART.
!
!  KEV     INTEGER.  (INPUT)
!          THE NUMBER OF DESIRED EIGENVALUES.
!
!  NP      INTEGER.  (INPUT)
!          THE NUMBER OF SHIFTS TO COMPUTE.
!
!  RITZ    COMPLEX*16 ARRAY OF LENGTH KEV+NP.  (INPUT/OUTPUT)
!          ON INPUT, RITZ CONTAINS THE THE EIGENVALUES OF H.
!          ON OUTPUT, RITZ ARE SORTED SO THAT THE UNWANTED
!          EIGENVALUES ARE IN THE FIRST NP LOCATIONS AND THE WANTED
!          PORTION IS IN THE LAST KEV LOCATIONS.  WHEN EXACT SHIFTS ARE
!          SELECTED, THE UNWANTED PART CORRESPONDS TO THE SHIFTS TO
!          BE APPLIED. ALSO, IF ISHIFT .EQ. 1, THE UNWANTED EIGENVALUES
!          ARE FURTHER SORTED SO THAT THE ONES WITH LARGEST RITZ VALUES
!          ARE FIRST.
!
!  BOUNDS  COMPLEX*16 ARRAY OF LENGTH KEV+NP.  (INPUT/OUTPUT)
!          ERROR BOUNDS CORRESPONDING TO THE ORDERING IN RITZ.
!
!
!
!\ENDDOC
!
!-----------------------------------------------------------------------
!
!\BEGINLIB
!
!\LOCAL VARIABLES:
!     XXXXXX  COMPLEX*16
!
!\ROUTINES CALLED:
!     ZSORTC  ARPACK SORTING ROUTINE.
!     IVOUT   ARPACK UTILITY ROUTINE THAT PRINTS INTEGERS.
!     SECOND  ARPACK UTILITY ROUTINE FOR TIMING.
!     ZVOUT   ARPACK UTILITY ROUTINE THAT PRINTS VECTORS.
!
!\AUTHOR
!     DANNY SORENSEN               PHUONG VU
!     RICHARD LEHOUCQ              CRPC / RICE UNIVERSITY
!     DEPT. OF COMPUTATIONAL &     HOUSTON, TEXAS
!     APPLIED MATHEMATICS
!     RICE UNIVERSITY
!     HOUSTON, TEXAS
!
!\SCCS INFORMATION: @(#)
! FILE: NGETS.F   SID: 2.2   DATE OF SID: 4/20/96   RELEASE: 2
!
!\REMARKS
!     1. THIS ROUTINE DOES NOT KEEP COMPLEX CONJUGATE PAIRS OF
!        EIGENVALUES TOGETHER.
!
!\ENDLIB
!
!-----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
!     %-----------------------------%
!     | INCLUDE FILES FOR DEBUGGING |
!     %-----------------------------%
!
#include "asterfort/ivout.h"
#include "asterfort/zsortc.h"
#include "asterfort/zvout.h"
    integer :: logfil, ndigit, mgetv0, mnaupd, mnaup2, mnaitr, mneigh, mnapps
    integer :: mngets, mneupd
    common /debug/&
     &  logfil, ndigit, mgetv0,&
     &  mnaupd, mnaup2, mnaitr, mneigh, mnapps, mngets, mneupd
!
!     %------------------%
!     | SCALAR ARGUMENTS |
!     %------------------%
!
    character(len=2) :: which
    integer :: ishift, kev, np
!
!     %-----------------%
!     | ARRAY ARGUMENTS |
!     %-----------------%
!
    complex(kind=8) :: bounds(kev+np), ritz(kev+np)
!
!     %------------%
!     | PARAMETERS |
!     %------------%
!
!
!     %---------------%
!     | LOCAL SCALARS |
!     %---------------%
!
    integer :: msglvl
!
!
!     %-----------------------%
!     | EXECUTABLE STATEMENTS |
!     %-----------------------%
!
!     %-------------------------------%
!     | INITIALIZE TIMING STATISTICS  |
!     | & MESSAGE LEVEL FOR DEBUGGING |
!     %-------------------------------%
!
    msglvl = mngets
!
    call zsortc(which, .true._1, kev+np, ritz, bounds)
!
    if (ishift .eq. 1) then
!
!        %-------------------------------------------------------%
!        | SORT THE UNWANTED RITZ VALUES USED AS SHIFTS SO THAT  |
!        | THE ONES WITH LARGEST RITZ ESTIMATES ARE FIRST        |
!        | THIS WILL TEND TO MINIMIZE THE EFFECTS OF THE         |
!        | FORWARD INSTABILITY OF THE ITERATION WHEN THE SHIFTS  |
!        | ARE APPLIED IN SUBROUTINE ZNAPPS.                     |
!        | BE CAREFUL AND USE 'SM' SINCE WE WANT TO SORT BOUNDS! |
!        %-------------------------------------------------------%
!
        call zsortc('SM', .true._1, np, bounds, ritz)
!
    endif
!
!
    if (msglvl .gt. 0) then
        call ivout(logfil, 1, [kev], ndigit, '_NGETS: KEV IS')
        call ivout(logfil, 1, [np], ndigit, '_NGETS: NP IS')
        call zvout(logfil, kev+np, ritz, ndigit, '_NGETS: EIGENVALUES OF CURRENT H MATRIX ')
        call zvout(logfil, kev+np, bounds, ndigit,&
                   '_NGETS: RITZ ESTIMATES OF THE CURRENT KEV+NP RITZ VALUES')
    endif
!
!
!     %---------------%
!     | END OF ZNGETS |
!     %---------------%
!
end subroutine
