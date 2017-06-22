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

subroutine xtlagf(ndim, nnc, jnn, nddls,&
                  jdepde, ffc,&
                  nfhe, dlagrf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/xplma2.h"
    integer :: ndim, nnc, jnn(3), nfhe
    integer :: jdepde
    real(kind=8) :: ffc(9)
    real(kind=8) :: dlagrf(2)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DES INCREMENTS - LAGRANGE DE FROTTEMENT
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
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
!
!
!
!
    integer :: idim, ino, nn, nns, nddls
    integer ::  pl
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    nn = jnn(1)
    nns= jnn(2)
!
    dlagrf(1) = 0.d0
    dlagrf(2) = 0.d0
!
! --- LAGRANGES DE FROTTEMENT
!
    do 221 idim = 2, ndim
        do 231 ino = 1, nnc
            call xplma2(ndim, nn, nns, nddls, ino,&
                        nfhe, pl)
            dlagrf(idim-1) = dlagrf(idim-1)+ ffc(ino)*zr(jdepde-1+pl+ idim-1)
231      continue
221  continue
!
!
end subroutine
