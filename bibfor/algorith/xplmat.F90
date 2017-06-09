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

subroutine xplmat(ddls, ddlc, ddlm,&
                  nnos, nnom, n, pl)
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
    integer :: ddls, ddlc, nnos, nnom, n, pl, ddlm
!
! person_in_charge: samuel.geniaut at edf.fr
!
!    CADRE : X-FEM ET CONTACT CONTINU
!             CALCULE LA PLACE DU LAMBDA(N) NORMAL DANS LA MATRICE
!             DE RAIDEUR DUE AU CONTACT
!
! IN  NFH     : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES
! IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
! IN  NNO     : NOMBRE DE NOEUDS SOMMET
! IN  NNOM    : NOMBRE DE NOEUDS MILIEU
! IN  N       : NUMÉRO DU NOEUD PORTANT LE LAMBDA
!
! OUT PL      : PLACE DU LMBDA DANS LA MATRICE
!     ------------------------------------------------------------------
!
    ASSERT(n.le.(nnos+nnom))
!
!     PLACE DU PREMIER DDL DE CONTACT POUR CHAQUE N
    if (n .le. nnos) then
        pl=ddls*n-ddlc+1
    else
        pl=ddls*nnos+ddlm*(n-nnos)-ddlc+1
    endif
!
end subroutine
