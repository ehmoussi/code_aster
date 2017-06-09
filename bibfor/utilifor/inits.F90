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

function inits(os, nos, eta)
!
! UTILISEE SOUS NT POUR L'EVALUATION DE LA FONCTION D'ERREUR
! ERFC  (PROVIENT DE LA BIBLIOTHEQUE SLATEC)
!
!***BEGIN PROLOGUE  INITS
!***PURPOSE  DETERMINE THE NUMBER OF TERMS NEEDED IN AN ORTHOGONAL
!            POLYNOMIAL SERIES SO THAT IT MEETS A SPECIFIED ACCURACY.
!***LIBRARY   SLATEC (FNLIB)
!***CATEGORY  C3A2
!***TYPE      DOUBLE PRECISION (INITS-S, INITDS-D)
!***KEYWORDS  CHEBYSHEV, FNLIB, INITIALIZE, ORTHOGONAL POLYNOMIAL,
!             ORTHOGONAL SERIES, SPECIAL FUNCTIONS
!***AUTHOR  FULLERTON, W., (LANL)
!***DESCRIPTION
!
!  INITIALIZE THE ORTHOGONAL SERIES, REPRESENTED BY THE ARRAY OS, SO
!  THAT INITS IS THE NUMBER OF TERMS NEEDED TO INSURE THE ERROR IS NO
!  LARGER THAN ETA.  ORDINARILY, ETA WILL BE CHOSEN TO BE ONE-TENTH
!  MACHINE PRECISION.
!
!             INPUT ARGUMENTS --
!   OS     DOUBLE PRECISION ARRAY OF NOS COEFFICIENTS IN AN ORTHOGONAL
!          SERIES.
!   NOS    NUMBER OF COEFFICIENTS IN OS.
!   ETA    SINGLE PRECISION SCALAR CONTAINING REQUESTED ACCURACY OF
!          SERIES.
!
!***END PROLOGUE  INITDS
    implicit none
    integer :: inits
#include "asterfort/assert.h"
    real(kind=8) :: os(*)
!***FIRST EXECUTABLE STATEMENT  INITDS
!-----------------------------------------------------------------------
    integer :: i, ii, nos
    real(kind=8) :: err, eta
!-----------------------------------------------------------------------
    ASSERT(nos .ge. 1)
!
    err = 0.d0
    do 10 ii = 1, nos
        i = nos + 1 - ii
        err = err + abs(os(i))
        if (err .gt. eta) goto 20
10  end do
!
20  continue
!     ASSERT SI SERIE DE CHEBYSHEV TROP COURTE POUR LA PRECISION
    ASSERT(i .ne. nos)
    inits = i
!
end function
