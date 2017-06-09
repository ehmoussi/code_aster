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

subroutine xplma2(ndim, nne, nnes, ndls, n,&
                  nfhe, pl)
!
!
    implicit none
#include "asterfort/assert.h"
    integer :: ndim, nne, nnes, n, pl, ndls, nfhe
!
! ----------------------------------------------------------------------
!
!    CADRE :  CALCULE LA PLACE DU LAMBDA(N) NORMAL DANS LA MATRICE
!             ET LE SECOND MEMBRE DE CONTACT
!
!----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
! IN  NDIM    : DIMENSION
! IN  DNE     : NOMBRE TOTAL DE NOEUDS ESCLAVES
! IN  NNES    : NOMBRE DE NOEUDS ESCLAVES SOMMETS
! IN  NDLS    : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! IN  N       : NUMÉRO DU NOEUD PORTANT LE LAMBDA
! IN  NFHE    : NOMBRE DE DDL HEAVISIDE ESCLAVES
!
! OUT PL      : PLACE DU LAMBDA DANS LA MATRICE
!
! ----------------------------------------------------------------------
!
    ASSERT(n.le.nne)
!
    if (n .le. nnes) then
        pl= ndls*n - ndim*max(1,nfhe) + 1
    else
        pl=nnes*3*ndim+ndim*(n-nnes-1)+1
    endif
!
end subroutine
