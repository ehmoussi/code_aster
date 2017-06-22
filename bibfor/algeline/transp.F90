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

subroutine transp(a, nlamax, dimal, dimac, b,&
                  nlbmax)
!
!    BUT : TRANSPOSEE DE LA MATRICE A DANS LA MATRICE B
!
!    IN  : NLAMAX    : NB DE LIGNES DE MATRICE A DIMENSIONNEES
!          DIMAL     : NB DE LIGNES DE MATRICE A UTILISEES
!          DIMAC     : NB DE COLONNES DE MATRICE A
!          A(DIMAL,DIMAC): MATRICE A
!          NLBMAX    : NB DE LIGNES DE MATRICE B DIMENSIONNEES
!
!    OUT : B(DIMAC,DIMAL): MATRICE TRANSPOSEE DE A
! ------------------------------------------------------------------
    implicit none
#include "asterfort/utmess.h"
    integer :: dimal, dimac
    real(kind=8) :: a(nlamax, *), b(nlbmax, *)
!-----------------------------------------------------------------------
    integer :: icol, ilig, nlamax, nlbmax
!-----------------------------------------------------------------------
    if (dimac .gt. nlbmax) then
        call utmess('F', 'ALGELINE3_51')
    endif
    do 10 ilig = 1, dimal
        do 5 icol = 1, dimac
            b(icol,ilig) = a(ilig,icol)
 5      continue
10  continue
end subroutine
