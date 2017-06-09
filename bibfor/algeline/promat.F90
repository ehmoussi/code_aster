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

subroutine promat(a, nlamax, dimal, dimac, b,&
                  nlbmax, dimbl, dimbc, res)
!
!    BUT : PRODUIT DE 2 MATRICES A*B DANS RES
!
!    IN  : NLAMAX    : NB DE LIGNES DE MATRICE A DIMENSIONNEES
!          DIMAL     : NB DE LIGNES DE MATRICE A UTILISEES
!          DIMAC     : NB DE COLONNES DE MATRICE A
!          A(DIMAL,DIMAC): MATRICE A
!          NLBMAX    : NB DE LIGNES DE MATRICE B DIMENSIONNEES
!          DIMBL     : NB DE LIGNES DE MATRICE B
!          DIMBC     : NB DE COLONNES DE MATRICE B
!          B(DIMBL,DIMBC): MATRICE B
!
!    OUT : RES(DIMAL,DIMBC): MATRICE PRODUIT DE A*B
! ------------------------------------------------------------------
    implicit none
#include "asterfort/utmess.h"
    integer :: dimac, dimal, dimbc, dimbl
    real(kind=8) :: a(nlamax, *), b(nlbmax, *), res(nlamax, *)
!-----------------------------------------------------------------------
    integer :: icol, ilig, k, nlamax, nlbmax
    real(kind=8) :: xaux
!-----------------------------------------------------------------------
    if (dimac .ne. dimbl) then
        call utmess('F', 'ALGELINE3_30')
    endif
    do 10 ilig = 1, dimal
        do 10 icol = 1, dimbc
            xaux=0.d0
            do 5 k = 1, dimac
                xaux=xaux+a(ilig,k)*b(k,icol)
 5          continue
            res(ilig,icol)=xaux
10      continue
end subroutine
