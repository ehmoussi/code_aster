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

subroutine xcalculgeo(ndim, vale, jvp, jbl, deltat, jbeta, &
                      jlistp, node, newlst, newlsn)
    implicit none
!
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/celces.h"
#include "asterfort/cescns.h"
#include "asterfort/cnscno.h"

    integer             :: jbl, jvp, jbeta, jlistp
    integer             :: node, ndim
    real(kind=8)        :: newlsn, newlst, deltat
    real(kind=8)        :: vale(:)
!
! person_in_charge: patrick.massin at edf.fr
!
!
!     ------------------------------------------------------------------
!
!   xcaclulgeo   : calcul géométrique pour les points problematiques

!    ENTREE
!        NDIM    : DIMENSION DE L'ESPACE
!        JCOOR   : COORDONNE DES NOEUDS
!        JVP     : VECTEUR DES VITESSES DE PROPAGATION EN CHAQUE POINT
!                  DU DOMAINE DE CALCUL (MODULE DE LA VITESSE DU POINT
!                  PROJETE SUR LE FOND DE LA FISSURE)
!        JBL     : CHAM_NO_S DES VECTEURS NORMALE ET TANGENTIELLE DE LA
!                  BASE LOCALE IN CHAQUE NODE DU MAILLAGE
!        DELTAT  : TEMPS TOTAL DU PAS DE PROPAGATION
!        JNODTO  : LISTE DES NOEUDS DEFINISSANT LE DOMAINE DE CALCUL
!        NBNO    : NOMBRE DE NOEUD DU TORE DE CALCUL
!        JBETA   : VECTEUR DES ANGLES DE BIFURCATION DE LA FISSURE
!                  EN CHAQUE POINT DU DOMAINE DE CALCUL (ANGLE AU POINT
!                  PROJETE SUR LE FOND DE LA FISSURE)
!        JLISTP  : VECTEUR (A 3 COMPOSANTES) OU LES CORDONNEES DU
!                  PROJETE DE CHAQUE POINT DU DOMAINE DE CALCUL SUR LE
!                  FOND DE LA FISSURE SONT STOCKEES
!        NODE    : NOEUD PROBLEMATIQUE TROUVE ET CALCULE PAR METHODE GEOMETRIQUE
!        NEWLSN  : VALEUR DU NOEUD A MODIFIE
!        NEWLSN  : VALEUR DU NOEUD A MODIFIE
!
!    SORTIE
!
!        NEWLSN  : VALEUR DU NOEUD MODIFIE PAR METHODE GEOMETRIQUE
!        NEWLSN  : VALEUR DU NOEUD MODIFIE PAR METHODE GEOMETRIQUE
!
!     ------------------------------------------------------------------

    integer                      :: k, pos, pos1
    real(kind=8),dimension(ndim) :: t1, n1, p1
    real(kind=8)                 :: deltaa, cbeta, sbeta
!
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------

!     PROPAGATION VECTOR DELTA_A
    deltaa=zr(jvp-1+node)*deltat
!
!     STORE THE COS AND SIN OF THE PROPAGATION ANGLE
    cbeta = cos(zr(jbeta-1+node))
    sbeta = sin(zr(jbeta-1+node))
!
!     POINTERS INSIDE THE JEVEUX OBJECTS
    pos = 2*ndim*(node-1)
    pos1 = 3*(node-1)
!
!     RESET THE NEW VALUE OF THE TWO LEVEL SETS
    newlsn = 0.d0
    newlst = 0.d0
!
    do k = 1, ndim
!        NEW T-AXIS BY A RIGID ROTATION AT THE NEW CRACK TIP
        t1(k) = cbeta*zr(jbl-1+pos+ndim+k)+sbeta*zr(jbl-1+pos+k)
!        NEW N-AXIS BY A RIGID ROTATION AT THE NEW CRACK TIP
        n1(k) = cbeta*zr(jbl-1+pos+k)-sbeta*zr(jbl-1+pos+ndim+k)
!        NEW CRACK TIP POSITION
        p1(k) = zr(jlistp-1+pos1+k)+deltaa*t1(k)
!        NEW VALUES OF THE TWO LEVEL SETS
        newlsn = newlsn+(vale(pos1+k)-p1(k))*n1(k)
        newlst = newlst+(vale(pos1+k)-p1(k))*t1(k)
    end do

end subroutine
