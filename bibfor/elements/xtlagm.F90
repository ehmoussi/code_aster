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

subroutine xtlagm(ndim, nnc, jnn, nddls,&
                  jdepde, ffc,&
                  lfrott, nfhe, lmulti, heavno,&
                  dlagrc, dlagrf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/xtlagc.h"
#include "asterfort/xtlagf.h"
    integer :: ndim, nnc, jnn(3), nddls, nfhe, heavno(8)
    integer :: jdepde
    real(kind=8) :: ffc(9)
    real(kind=8) :: dlagrc, dlagrf(2)
    aster_logical :: lfrott, lmulti
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
!
! DEPDEL - INCREMENT DE DEPLACEMENT DEPUIS DEBUT DU PAS DE TEMPS
!
! IN  NDIM   : DIMENSION DU MODELE
! IN  NNC    : NOMBRE DE NOEUDS DE CONTACT
! IN  NN     : NOMBRE DE NOEUDS
! IN  NNS    : NOMBRE DE NOEUDS SOMMETS
! IN  NDDLS  : NOMBRE DE DDL SUR UN NOEUD SOMMET
! IN  JDEPDE : POINTEUR JEVEUX POUR DEPDEL
! IN  FFC    : FONCTIONS DE FORMES LAGR.
! IN  TYPMAI : TYPE DE LA MAILLE
! IN  LFROTT : .TRUE. SI FROTTEMENT
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
!
! ----------------------------------------------------------------------
!
    call xtlagc(ndim, nnc, jnn, nddls,&
                jdepde, ffc,&
                nfhe, lmulti, heavno, dlagrc)
!
    if (lfrott) then
        call xtlagf(ndim, nnc, jnn, nddls,&
                    jdepde, ffc,&
                    nfhe, dlagrf)
    endif
!
end subroutine
