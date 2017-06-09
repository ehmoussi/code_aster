! --------------------------------------------------------------------
! Copyright (C) LAPACK / BLAS
! Copyright (C) 2007 - 2017 - EDF R&D - www.code-aster.org
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

subroutine xerbla(srname, info)
!
!     SUBROUTINE LAPACK / BLAS DE TRAITEMENT DES ERREURS.
!-----------------------------------------------------------------------
!  -- LAPACK AUXILIARY ROUTINE (VERSION 2.0) --
!     UNIV. OF TENNESSEE, UNIV. OF CALIFORNIA BERKELEY, NAG LTD.,
!     COURANT INSTITUTE, ARGONNE NATIONAL LAB, AND RICE UNIVERSITY
!     SEPTEMBER 30, 1994
!
!  PURPOSE
!  =======
!
!  XERBLA  IS AN ERROR HANDLER FOR THE LAPACK ROUTINES.
!  IT IS CALLED BY AN LAPACK ROUTINE IF AN INPUT PARAMETER HAS AN
!  INVALID VALUE.  A MESSAGE IS PRINTED AND EXECUTION STOPS.
!
!  INSTALLERS MAY CONSIDER MODIFYING THE STOP STATEMENT IN ORDER TO
!  CALL SYSTEM-SPECIFIC EXCEPTION-HANDLING FACILITIES.
!
!  ARGUMENTS
!  =========
!
!  SRNAME  (INPUT) CHARACTER*6
!          THE NAME OF THE ROUTINE WHICH CALLED XERBLA.
!
!  INFO    (INPUT) INTEGER
!          THE POSITION OF THE INVALID PARAMETER IN THE PARAMETER LIST
!          OF THE CALLING ROUTINE.
!
! ASTER INFORMATION
! 11/01/2000 TOILETTAGE DU FORTRAN SUIVANT LES REGLES ASTER,
!            AU LIEU DE WRITE(*,FMT=9999)SRNAME,INFO
!            IMPLICIT NONE
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
#include "asterfort/utmess.h"
!
!     .. SCALAR ARGUMENTS ..
    character(len=6) :: srname
    character(len=24) :: valk
    integer :: info
    integer :: vali(2)
!     ..
!     .. EXECUTABLE STATEMENTS ..
!
    valk = srname
    vali (1) = info
    vali (2) = info
    call utmess('F', 'ALGELINE5_4', sk=valk, ni=2, vali=vali)
!
!     END OF XERBLA
!
end subroutine
