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

subroutine mmlagm(nbdm, ndim, nnl, jdepde, ffl,&
                  dlagrc, dlagrf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
    integer :: nbdm, ndim, nnl
    integer :: jdepde
    real(kind=8) :: ffl(9)
    real(kind=8) :: dlagrc, dlagrf(2)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
!
! ----------------------------------------------------------------------
!
!
! DEPDEL - INCREMENT DE DEPLACEMENT DEPUIS DEBUT DU PAS DE TEMPS
! GEOMAx - GEOMETRIE ACTUALISEE GEOM_INIT + DEPMOI
!
!
! IN  NBDM   : NB DE DDL DE LA MAILLE ESCLAVE
!                NDIM = 2 -> NBDM = DX/DY/LAGR_C/LAGR_F1
!                NDIM = 3 -> NBDM = DX/DY/DZ/LAGR_C/LAGR_F1/LAGR_F2
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNL    : NOMBRE DE NOEUDS LAGRANGE
! IN  JDEPDE : ADRESSE JEVEUX POUR DEPDEL
! IN  FFL    : FONCTIONS DE FORMES LAGR.
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
!
!
!
!
    integer :: inoc, inof
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    dlagrc = 0.d0
    dlagrf(1) = 0.d0
    dlagrf(2) = 0.d0
!
! --- LAGRANGE DE CONTACT AU POINT D'INTEGRATION
!
    do 132 inoc = 1, nnl
        dlagrc = dlagrc + ffl(inoc)* zr(jdepde+(inoc-1)*nbdm+(ndim+1)- 1)
132  end do
!
! --- LAGRANGES DE FROTTEMENT AU POINT D'INTEGRATION
!
    do 133 inof = 1, nnl
        dlagrf(1) = dlagrf(1) + ffl(inof)* zr(jdepde+(inof-1)*nbdm+( ndim+2)-1)
        if (ndim .eq. 3) then
            dlagrf(2) = dlagrf(2) + ffl(inof)* zr(jdepde+(inof-1)* nbdm+(ndim+3)-1)
        endif
133  end do
!
!
end subroutine
