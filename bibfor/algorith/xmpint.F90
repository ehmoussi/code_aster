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

subroutine xmpint(ndim, npte, nfaes, jpcpi, jpccf,&
                  geopi)
!
!
    implicit none
#include "jeveux.h"
    integer :: jpcpi, jpccf
    integer :: ndim, nfaes, npte
    real(kind=8) :: geopi(18)
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (METHODE XFEM-GG - TE)
!
! CALCUL DES COORDONNEES REELLE POUR LES POINTS
! D'INTERSECTION CONSTITUENT LA MAILLE DE CONTACT
! DANS L'ELEMENT DE CONTACT HYBRIDE X-FEM
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
! IN  NFAES  : NUMERO DE LA FACETTE ESCLAVE
! IN  JPCPI  : COORDONNÉES DES POINTS D'INTERSECTION DANS L'ELEM DE REF
! IN  JPCCF  : NUM LOCAUX DES NOEUDS DES FACETTES DE CONTACT
! OUT GEOPI  : COORDONNÉES REELES DES POINTS D'INTERSECTION
!
!
!
!
    integer :: i, j
!
! ----------------------------------------------------------------------
!
!
    do 30 i = 1, npte
! --- BOUCLE SUR LES POINTS D'INTERSECTION DE LA FACETTE
        do 40 j = 1, ndim
            geopi(ndim*(i-1)+j) = zr( jpcpi-1+ndim*(zi(jpccf-1+npte*( nfaes-1)+i)-1 )+j )
40      continue
30  continue
!
end subroutine
