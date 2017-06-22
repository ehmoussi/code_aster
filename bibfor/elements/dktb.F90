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

subroutine dktb(carat3, igau, jacgau, bmat)
    implicit  none
#include "jeveux.h"
#include "asterfort/bcoqaf.h"
#include "asterfort/dktbf.h"
#include "asterfort/dxtbm.h"
#include "asterfort/elrefe_info.h"
    integer :: igau
    real(kind=8) :: bmat(8, 1), carat3(*), jacgau
! --- CALCUL DE LA MATRICE (B) RELIANT LES DEFORMATIONS DU PREMIER
! --- ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION D'INDICE IGAU
! --- POUR UN ELEMENT DE TYPE DKT
! --- (I.E. (EPS_1) = (B)*(UN))
! --- D'AUTRE_PART, ON CALCULE LE PRODUIT NOTE JACGAU = JACOBIEN*POIDS
!     ------------------------------------------------------------------
!     IN  IGAU          : INDICE DU POINT D'INTEGRATION
!     OUT JACGAU        : PRODUIT JACOBIEN*POIDS AU POINT D'INTEGRATION
!                         COURANT
!     OUT BMAT(8,1)     : MATRICE (B) AU POINT D'INTEGRATION COURANT
    integer :: ndim, nno, nnos, npg, ipoids, icoopg, ivf, idfdx, idfd2, jgano
    integer :: i, j
    real(kind=8) :: qsi, eta, bm(3, 6), bf(3, 9), bc(2, 9)
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jcoopg=icoopg,jvf=ivf,jdfde=idfdx,&
  jdfd2=idfd2,jgano=jgano)
!
! --- COORDONNEES DU POINT D'INTEGRATION COURANT :
!     ------------------------------------------
    qsi = zr(icoopg-1+ndim*(igau-1)+1)
    eta = zr(icoopg-1+ndim*(igau-1)+2)
!
! --- PRODUIT JACOBIEN*POIDS
!     ----------------------
    jacgau = zr(ipoids+igau-1)*carat3(7)
!
! --- CALCUL DE LA MATRICE B_MEMBRANE NOTEE, ICI, (BM)
!     ------------------------------------------------
    call dxtbm(carat3(9), bm)
!
! --- CALCUL DE LA MATRICE B_FLEXION RELATIVE AUX INCONNUES W, BETAX
! --- ET BETAY.
! --- CETTE MATRICE PREND EN COMPTE L'INTERPOLATION QUADRATIQUE
! --- DES ROTATIONS EN FONCTION DES INCONNUES ALFA.
! --- ON RAPPELLE QUE CES INCONNUES SONT DEFINIES AU MILIEU DES COTES
! --- DE TELLE MANIERE QUE LA COMPOSANTE DES ROTATIONS LE LONG DES
! --- COTES EST UNE FONCTION QUADRATIQUE DE L'ABSCISSE CURVILIGNE.
! --- CES INCONNUES ALFA SONT ELIMINEES GRACE A LA RELATION :
! ---  (ALFA) = (AN)*(UN)
! --- AVEC (UN) = (...,W_I,BETAX_I,BETAY_I,...)
! --- CETTE MATRICE (AN) EST CALCULEE IMPLICITEMENT DANS DKTBF
!     --------------------------------------------------------
    call dktbf(qsi, eta, carat3, bf)
!
! --- MISE A ZERO DE LA PARTIE (BC) DE LA MATRICE (B) RELATIVE
! --- AU CISAILLEMENT
!     ---------------
    do 10 i = 1, 2
        do 20 j = 1, 9
            bc(i,j) = 0.0d0
20      continue
10  end do
!
! --- AFFECTATION DE LA MATRICE B COMPLETE, NOTEE (BMAT)
! --- AVEC LES MATRICES (BM), (BF) ET (BC)
!     ------------------------------------
    call bcoqaf(bm, bf, bc, nno, bmat)
!
end subroutine
