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

subroutine xrmev2(cpt, npg, ndim, igeom, jsigse,&
                  coorse, tvolse)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/ermev2.h"
    integer :: cpt, npg, ndim, igeom, jsigse
    real(kind=8) :: tvolse, coorse(*)
!  XFEM - ERREUR EN MECANIQUE - TERME VOLUMIQUE - DIMENSION 2
!  *       *        **                *                     *
! =====================================================================
!
!     BUT:
!         CALCUL (AU SEIN DU SOUS-ELEMENT XFEM COURANT) DU CARRE DU
!         TERME VOLUMIQUE DE L'INDICATEUR D'ERREUR EN RESIDU
!         DANS LE CAS 2D
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   CPT    : NUMERO DU SOUS-ELEMENT COURANT
! IN   NPG    : NOMBRE DE POINTS DE GAUSS DU SOUS-ELEMENT
! IN   NDIM   : DIMENSION
! IN   IGEOM  : ADRESSE DU CHAMP DE GEOMETRIE
! IN   JSIGSE : ADRESSE DU CHAMP DE CONTRAINTES AUX NOEUDS
!               DU SOUS-ELEMENT
! IN   COORSE : LES COORDONNEES DES NOEUDS DU SOUS-ELEMENT
!               DANS LE REPERE REEL
!
!      SORTIE :
!-------------
! OUT  TVOLSE : CARRE DU TERME VOLUMIQUE DE L'INDICATEUR D'ERREUR
!
! ......................................................................
!
!
!
!
    integer :: nbcmp
    parameter(nbcmp=4)
!
    real(kind=8) :: dfdx(3), dfdy(3), poijac, dsx, dsy, norme, signse(nbcmp*27)
    integer :: ndimb, nno, nnos, npgbis, ipoids, jcoopg, ivf, idfde, jdfd2
    integer :: jgano
    integer :: kpg, n, ibid, icmp, iadpg
!
! ----------------------------------------------------------------------
!
    call elrefe_info(elrefe='TR3',fami='XINT',ndim=ndimb,nno=nno,nnos=nnos,&
  npg=npgbis,jpoids=ipoids,jcoopg=jcoopg,jvf=ivf,jdfde=idfde,&
  jdfd2=jdfd2,jgano=jgano)
    ASSERT(npg.eq.npgbis.and.ndim.eq.ndimb)
!
    tvolse=0.d0
!
! --- ECRITURE POUR LE SOUS-ELEMENT COURANT D'UN TABLEAU DE CONTRAINTES
! --- AUX NOEUDS UTILISABLE PAR LA ROUTINE ERMEV2
!
    do 100 n = 1, nno
        do 110 icmp = 1, nbcmp
            signse(nbcmp*(n-1)+icmp)= zr(jsigse-1+nbcmp*nno*(cpt-1)+&
            nbcmp*(n-1)+icmp)
110      continue
100  end do
!
! ----------------------------------------------------------------------
! --------- BOUCLE SUR LES POINTS DE GAUSS DU SOUS ELEMENT -------------
! ----------------------------------------------------------------------
!
    do 200 kpg = 1, npg
!
! --- CALCUL DES DERIVEES DES FONCTIONS DE FORME DU SOUS-ELEMENT -------
! --- AU POINT DE GAUSS COURANT DANS LE REPERE REEL -------------------
!
        call dfdm2d(nno, kpg, ipoids, idfde, coorse,&
                    poijac, dfdx, dfdy)
!
! --- CALCUL DE LA DIVERGENCE ET DE LA NORME DE SIGMA ------------------
!
        iadpg=ivf+(kpg-1)*nno
        ibid = 1
        call ermev2(nno, igeom, zr(iadpg), signse, nbcmp,&
                    dfdx, dfdy, poijac, ibid, dsx,&
                    dsy, norme)
!
! --- CALCUL DU TERME VOLUMIQUE AVEC INTEGRATION DE GAUSS --------------
!
        tvolse=tvolse+(dsx**2+dsy**2)*poijac
!
200  end do
!
end subroutine
