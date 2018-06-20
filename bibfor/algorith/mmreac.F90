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

subroutine mmreac(nbdm  ,ndim  ,nne   ,nnm   ,jgeom , &
                  jdepm ,jdepde,ppe,geomae,geomam,ddepmam)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"

    real(kind=8) :: ppe
    integer :: nbdm, ndim, nne, nnm
    integer :: jgeom, jdepm,jdepde
    real(kind=8) :: geomae(9, 3), geomam(9, 3), ddepmam(9, 3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - TE)
!
! MISE A JOUR DE LA GEOMETRIE
!
! ----------------------------------------------------------------------
!
! GEOM = GEOM_INIT + DEPMOI
!
! IN  NBDM   : NB DE DDL DE LA MAILLE ESCLAVE
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  NNE    : NOMBRE DE NOEUDS ESCLAVES
! IN  NNM    : NOMBRE DE NOEUDS MAITRES
! IN  JGEOM  : POINTEUR JEVEUX SUR GEOMETRIE INITIALE (MAILLAGE)
! IN  JDEPM  : POINTEUR JEVEUX SUR CHAMP DE DEPLACEMENT A L'INSTANT
!              PRECEDENT
! IN PPE     : LA REACTUALISATION DES NORMALES N'EST PAS LA MEME EN NEWTON GENE
!                   PPE = 0 --> POINT_FIXE
!                    PPE = 1 --> NEWTON_GENE (FULL)
!            0<PPE<1 --> NEWTON_GENE (AVEC NORMALE INEXACTE)
! OUT GEOMAE : GEOMETRIE ACTUALISEE SUR NOEUDS ESCLAVES
! OUT GEOMAM : GEOMETRIE ACTUALISEE SUR NOEUDS MAITRES
!
    integer :: inoe, inom, idim
!
! ----------------------------------------------------------------------
!
!
    geomae = 0.d0
    geomam = 0.d0
!
! --- NOEUDS ESCLAVES
!
    do  inoe = 1, nne
        do 110 idim = 1, ndim
            geomae(inoe,idim) = zr( jgeom+(inoe-1)*ndim+idim-1) + zr(jdepm+(inoe-1)*nbdm+idim-1)&
                                             +ppe* zr(jdepde+(inoe-1)*nbdm+idim-1)
110      continue
  end do
!
! --- NOEUDS MAITRES
!
    do  inom = 1, nnm
        do 122 idim = 1, ndim
            geomam(inom,idim) = zr(&
                                jgeom+nne*ndim+(inom-1)*ndim+idim- 1)+ zr(jdepm+nne*nbdm+(inom-1)&
                                &*ndim+idim-1&
                                ) + ppe*zr(jdepde+nne*nbdm+(inom-1)&
                                &*ndim+idim-1&
                                )


            ddepmam(inom,idim) =   zr(jdepde+nne*nbdm+(inom-1)&
                                &*ndim+idim-1&
                                )


122      continue
  end do
!
!
end subroutine
