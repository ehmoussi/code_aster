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

subroutine xtlagc(ndim, nnc, jnn, nddls,&
                  jdepde, ffc,&
                  nfhe, lmulti, heavno, dlagrc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/xplma2.h"
    integer :: ndim, nnc, jnn(3), nfhe
    integer :: jdepde, heavno(8)
    real(kind=8) :: ffc(9)
    real(kind=8) :: dlagrc
    aster_logical :: lmulti
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DES INCREMENTS - LAGRANGE DE CONTACT
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
! IN  NDDLS  : NOMBRE DE DDL SUR UN NOEUD SOMMET
! IN  NNS    : NOMBRE DE NOEUDS SOMMETS
! IN  JDEPDE : ADRESSE JEVEUX POUR DEPDEL
! IN  FFC    : FONCTIONS DE FORMES LAGR.
! IN  TYPMAI : TYPE DE LA MAILLE
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
!
!
!
!
    integer :: ino
    integer :: pl, nn, nns, nddls
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    nn = jnn(1)
    nns= jnn(2)
!
    dlagrc = 0.d0
!
! --- LAGRANGE DE CONTACT
!
    do 230 ino = 1, nnc
        call xplma2(ndim, nn, nns, nddls, ino,&
                    nfhe, pl)
        if (lmulti) pl = pl + (heavno(ino)-1)*ndim
        dlagrc = dlagrc+ffc(ino)*zr(jdepde-1+pl+1-1)
230 continue
!
!
end subroutine
