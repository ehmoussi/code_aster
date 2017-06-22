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

subroutine te0117(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/bsigmc.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
! FONCTION REALISEE:  CALCUL DE L'OPTION FORC_NODA
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
    real(kind=8) :: nharm, bsigm(18)
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfde
    integer :: jgano
! DEB ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, icontm, igeom, iharmo, ivectu, nbsig, nh
!
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
! --- INITIALISATIONS :
!     -----------------
    zero = 0.0d0
    nharm = zero
!
! ---- RECUPERATION  DU NUMERO D'HARMONIQUE
!      ------------------------------------
    call jevech('PHARMON', 'L', iharmo)
    nh = zi(iharmo)
    nharm = dble(nh)
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
    nbsig = nbsigm()
!
! ---- PARAMETRES EN ENTREE
!      --------------------
! ----     COORDONNEES DES CONNECTIVITES
    call jevech('PGEOMER', 'L', igeom)
! ----     CONTRAINTES AUX POINTS D'INTEGRATION
    call jevech('PCONTMR', 'L', icontm)
!
! ---- PARAMETRES EN SORTIE
!      --------------------
! ----     VECTEUR DES FORCES INTERNES (BT*SIGMA)
    call jevech('PVECTUR', 'E', ivectu)
!
! ---- CALCUL DU VECTEUR DES FORCES INTERNES (BT*SIGMA) :
!      --------------------------------------------------
    call bsigmc(nno, ndim, nbsig, npg, ipoids,&
                ivf, idfde, zr(igeom), nharm, zr(icontm),&
                bsigm)
!
! ---- AFFECTATION DU VECTEUR EN SORTIE :
!      ----------------------------------
    do 10 i = 1, ndim*nno
        zr(ivectu+i-1) = bsigm(i)
10  continue
!
! FIN ------------------------------------------------------------------
end subroutine
