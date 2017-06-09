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

subroutine premld(n1, diag, col, xadj1, adjnc1,&
                  nnz, deb, voisin, suiv, ladjn,&
                  nrl)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
#include "asterfort/caladj.h"
    integer :: n1, diag(0:*), col(*)
    integer :: xadj1(n1+1), adjnc1(*)
    integer :: voisin(*), suiv(*)
!     VARIABLES LOCALES
    integer :: lmat
    integer :: nnz(1:n1), deb(1:n1), ladjn
    integer :: nrl
!-------------------------------------------------------
!      1) A PARTIR DE DIAG ET COL -> ADJNC1
!       AVEC TOUS LES DDL ASTER   (1:N1)
!       CETTE ROUTINE NECESSITE 3*LMAT DE LONGUEUR DE TRAVAIL
!       COL (LMAT)
!       ADJNC1(2*(LMAT-N1))
!       DEB(1:N1)
!       SUIV(LT)
!       VOISIN(LT)
!     CES 3 TABLEAUX NE SONT UTILISES QU'AVEC LES RELATIONS LINEAIRES
!     ENTRE DDL (NRL >0)
!-------------------------------------------------------
    lmat = diag(n1)
    call caladj(col, diag, xadj1, adjnc1, n1,&
                nnz, deb, voisin, suiv, lmat,&
                ladjn, nrl)
end subroutine
