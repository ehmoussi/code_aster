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

subroutine te0115(option, nomte)
! ......................................................................
    implicit none
!     BUT: CALCUL DES CONTRAINTES AUX POINTS DE GAUSS EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 2D FOURIER
!
!            OPTION : 'SIEF_ELGA   '
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
#include "asterfort/ortrep.h"
#include "asterfort/r8inir.h"
#include "asterfort/sigvmc.h"
    character(len=16) :: option, nomte
    character(len=4) :: fami
    real(kind=8) :: sigma(54), repere(7), instan, nharm
    real(kind=8) :: r8bid1(9), bary(3)
    integer :: ndim, nno, nnos, npg1, ipoids, ivf, dimmod
    integer :: idfde, jgano, idim
!
!
!-----------------------------------------------------------------------
    integer :: i, icont, idepl, igeom, iharmo, imate, nbsig
    integer :: nh
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    fami = 'RIGI'
    call elrefe_info(fami=fami,ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
    dimmod = 3
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
    nbsig = nbsigm()
!
! --- INITIALISATIONS :
!     -----------------
    zero = 0.0d0
    instan = zero
    nharm = zero
    call r8inir(9, 0.d0, r8bid1, 1)
!
    do 10 i = 1, nbsig*npg1
        sigma(i) = zero
10  end do
!
! ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
!      ----------------------------------------------
    call jevech('PGEOMER', 'L', igeom)
!
! ---- RECUPERATION DU MATERIAU
!      ------------------------
    call jevech('PMATERC', 'L', imate)
!
! ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
!      ------------------------------------------------------------
!     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )
!
    bary(1) = 0.d0
    bary(2) = 0.d0
    bary(3) = 0.d0
    do 150 i = 1, nno
        do 140 idim = 1, ndim
            bary(idim) = bary(idim)+zr(igeom+idim+ndim*(i-1)-1)/nno
140      continue
150  end do
    call ortrep(ndim, bary, repere)
!
! ---- RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
!      --------------------------------------------------
    call jevech('PDEPLAR', 'L', idepl)
!
! ---- RECUPERATION  DU NUMERO D'HARMONIQUE
!      ------------------------------------
    call jevech('PHARMON', 'L', iharmo)
    nh = zi(iharmo)
    nharm = dble(nh)
!
! ---- RECUPERATION DU VECTEUR DES CONTRAINTES EN SORTIE
!      -------------------------------------------------
    call jevech('PCONTRR', 'E', icont)
!
! ---- CALCUL DES CONTRAINTES 'VRAIES' AUX POINTS D'INTEGRATION
! ---- DE L'ELEMENT :
! ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
!      ------------------------------------
    call sigvmc(fami, nno, dimmod, nbsig, npg1,&
                ipoids, ivf, idfde, zr(igeom), zr(idepl),&
                instan, repere, zi(imate), nharm, sigma)
!
! ---- AFFECTATION DU VECTEUR EN SORTIE AVEC LES CONTRAINTES AUX
! ---- POINTS D'INTEGRATION
!      --------------------
    do 20 i = 1, nbsig*npg1
        zr(icont+i-1) = sigma(i)
20  end do
!
end subroutine
