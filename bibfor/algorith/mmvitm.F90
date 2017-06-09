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

subroutine mmvitm(nbdm, ndim, nne, nnm, ffe,&
                  ffm, jvitm, jaccm, jvitp, vitme,&
                  vitmm, vitpe, vitpm, accme, accmm)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
    integer :: nbdm, ndim, nne, nnm
    real(kind=8) :: ffe(9), ffm(9)
    integer :: jvitm, jvitp, jaccm
    real(kind=8) :: accme(3), vitme(3), accmm(3), vitmm(3)
    real(kind=8) :: vitpe(3), vitpm(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES VITESSES/ACCELERATIONS
!
! ----------------------------------------------------------------------
!
!
! DEPDEL - INCREMENT DE DEPLACEMENT DEPUIS DEBUT DU PAS DE TEMPS
! DEPMOI - DEPLACEMENT DEBUT DU PAS DE TEMPS
! GEOMAx - GEOMETRIE ACTUALISEE GEOM_INIT + DEPMOI
!
!
!
! IN  NBDM   : NB DE DDL DE LA MAILLE ESCLAVE
!                NDIM = 2 -> NBDM = DX/DY/LAGR_C/LAGR_F1
!                NDIM = 3 -> NBDM = DX/DY/DZ/LAGR_C/LAGR_F1/LAGR_F2
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  FFE    : FONCTIONS DE FORMES DEPL. ESCL.
! IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN  JVITM  : ADRESSE JEVEUX POUR CHAMP DE VITESSES A L'INSTANT
!              PRECEDENT
! IN  JVITP  : ADRESSE JEVEUX POUR CHAMP DE VITESSES A L'INSTANT
!              COURANT
! IN  JACCM  : ADRESSE JEVEUX POUR CHAMP D'ACCELERATIONS A L'INSTANT
!               PRECEDENT
! OUT VITME  : VITESSE PRECEDENTE DU POINT DE CONTACT
! OUT ACCME  : ACCELERATION PRECEDENTE DU POINT DU CONTACT
! OUT VITMM  : VITESSE PRECEDENTE DU PROJETE DU POINT DE CONTACT
! OUT ACCMM  : ACCELERATION PRECEDENTE  DU PROJETE DU POINT DU CONTACT
! OUT VITPE  : VITESSE COURANTE DU POINT DE CONTACT
! OUT VITPM  : VITESSE COURANTE DU PROJETE DU POINT DU CONTACT
!
!
!
!
    integer :: idim, inoe, inom
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    do 10 idim = 1, 3
        vitpm(idim) = 0.d0
        vitpe(idim) = 0.d0
        vitme(idim) = 0.d0
        accme(idim) = 0.d0
        vitmm(idim) = 0.d0
        accmm(idim) = 0.d0
        vitpe(idim) = 0.d0
10  end do
!
! --- POUR LES NOEUDS ESCLAVES
!
    do 31 idim = 1, ndim
        do 32 inoe = 1, nne
            vitpe(idim) = vitpe(idim) + ffe(inoe)* zr(jvitp+(inoe-1)* nbdm+idim-1)
            vitme(idim) = vitme(idim) + ffe(inoe)* zr(jvitm+(inoe-1)* nbdm+idim-1)
            accme(idim) = accme(idim) + ffe(inoe)* zr(jaccm+(inoe-1)* nbdm+idim-1)
!
32      continue
31  end do
!
! --- POUR LES NOEUDS MAITRES
!
    do 41 idim = 1, ndim
        do 42 inom = 1, nnm
            vitpm(idim) = vitpm(idim) + ffm(inom)* zr(jvitp+nne*nbdm+( inom-1)*ndim+idim-1)
            vitmm(idim) = vitmm(idim) + ffm(inom)* zr(jvitm+nne*nbdm+( inom-1)*ndim+idim-1)
            accmm(idim) = accmm(idim) + ffm(inom)* zr(jaccm+nne*nbdm+( inom-1)*ndim+idim-1)
!
42      continue
41  end do
!
!
end subroutine
