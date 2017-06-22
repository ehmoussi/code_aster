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

subroutine xmmaa0(ndim, nnc, jnne, hpg,&
                  ffc, jacobi, coefcr,&
                  coefcp, lpenac, jddle,&
                  nfhe, lmulti, heavno, mmat)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/xplma2.h"
    integer :: ndim, nnc, jnne(3), jddle(2)
    integer :: nfhe, heavno(8)
    real(kind=8) :: mmat(336, 336)
    real(kind=8) :: hpg, ffc(8), jacobi, coefcr, coefcp
    aster_logical :: lpenac, lmulti
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DE C POUR LE CONTACT METHODE CONTINUE
! CAS SANS CONTACT (XFEM)
!
!
! ----------------------------------------------------------------------
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNC    : NOMBRE DE NOEUDS DE CONTACT
! IN  NNE    : NOMBRE TOTAL DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
! IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFC    : FONCTIONS DE FORME DU POINT DE CONTACT DANS ELC
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  COEFCA : COEF_REGU_CONT
! IN  TYPMAI : NOM DE LA MAILLE ESCLAVE D'ORIGINE (QUADRATIQUE)
! IN  DDLES : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
!
! ----------------------------------------------------------------------
!
    integer :: i, j, pli, plj, nne, nnes, ddles
!
! ----------------------------------------------------------------------
!
    nne=jnne(1)
    nnes=jnne(2)
    ddles=jddle(1)
!
! ---  BOUCLE SUR LES NOEUDS PORTANT DES DDL DE CONTACT
    do 10 i = 1, nnc
! --- BOUCLE SUR LES NOEUDS PORTANT DES DDL DE CONTACT
        do 20 j = 1, nnc
            call xplma2(ndim, nne, nnes, ddles, i,&
                        nfhe, pli)
            if (lmulti) pli = pli + (heavno(i)-1)*ndim
            call xplma2(ndim, nne, nnes, ddles, j,&
                        nfhe, plj)
            if (lmulti) plj = plj + (heavno(j)-1)*ndim
            if (lpenac) then
                mmat(pli,plj) = -hpg*ffc(j)*ffc(i)*jacobi/coefcp
            else
                mmat(pli,plj) = -hpg*ffc(j)*ffc(i)*jacobi/coefcr
            endif
 20     continue
 10 continue
!
end subroutine
