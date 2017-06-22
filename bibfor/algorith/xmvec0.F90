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

subroutine xmvec0(ndim, jnne, nnc, dlagrc,&
                  hpg, ffc, jacobi,&
                  coefcr, coefcp, lpenac, jddle,&
                  nfhe, lmulti, heavno, vtmp)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/xplma2.h"
    integer :: ndim, jnne(3), nnc, jddle(2)
    integer :: nfhe, heavno(8)
    real(kind=8) :: dlagrc, hpg, ffc(9), jacobi, coefcr, coefcp
    real(kind=8) :: vtmp(336)
    aster_logical :: lpenac, lmulti
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! VECTEUR SECOND MEMBRE SI PAS DE CONTACT (X-FEM)
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  DLAGRC : LAGRANGE DE CONTACT AU POINT D'INTÉGRATION
! IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFC    : FONCTIONS DE FORME DU POINT DE CONTACT
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  COEFCA : COEF_REGU_CONT
! IN  COEFFS : COEF_STAB_CONT
! IN  COEFFP : COEF_PENA_CONT
! IN  DDLES  : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! I/O VTMP   : VECTEUR SECOND MEMBRE ELEMENTAIRE DE CONTACT/FROTTEMENT
! ----------------------------------------------------------------------
!
    integer :: i, pl, nne, nnes, ddles
!
! ----------------------------------------------------------------------
!
! --------------------- CALCUL DE {L2_CONT}-----------------------------
!
    nne=jnne(1)
    nnes=jnne(2)
    ddles=jddle(1)
!
    do 10 i = 1, nnc
        call xplma2(ndim, nne, nnes, ddles, i,&
                    nfhe, pl)
        if (lmulti) pl = pl + (heavno(i)-1)*ndim
        if (lpenac) then
            vtmp(pl) = -hpg*jacobi*dlagrc*ffc(i)/coefcp
        else
            vtmp(pl) = -hpg*jacobi*dlagrc*ffc(i)/coefcr
        endif
 10 continue
!
end subroutine
