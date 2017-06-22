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

subroutine rc36sp(nbm, ima, ipt, c, k,&
                  cara, mati, pi, mi, matj,&
                  pj, mj, mse, nbthp, nbthq,&
                  ioc1, ioc2, spij, typeke, spmeca,&
                  spther)
! aslint: disable=W1504
    implicit none
#include "asterfort/rcsp01.h"
#include "asterfort/utmess.h"
    integer :: nbm, ima(*), ipt, nbthp, nbthq
    real(kind=8) :: c(*), k(*), cara(*), mati(*), matj(*), pi, mi(*), pj, mj(*)
    real(kind=8) :: mse(*), spij, typeke, spmeca, spther
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!     CALCUL DU SN
!
! IN  : IMA    : NUMERO DE LA MAILLE TRAITEE
! IN  : IPT    : NUMERO DU NOEUD TRAITE
! IN  : C      : INDICES DE CONTRAINTES
! IN  : K      : INDICES DE CONTRAINTES
! IN  : CARA   : CARACTERISTIQUES ELEMENTAIRES
! IN  : MATI   : MATERIAU ASSOCIE A L'ETAT STABILISE I
! IN  : PI     : PRESSION ASSOCIEE A L'ETAT STABILISE I
! IN  : MI     : MOMENTS ASSOCIEES A L'ETAT STABILISE I
! IN  : MATJ   : MATERIAU ASSOCIE A L'ETAT STABILISE J
! IN  : PJ     : PRESSION ASSOCIEE A L'ETAT STABILISE J
! IN  : MJ     : MOMENTS ASSOCIEES A L'ETAT STABILISE J
! IN  : PJ     : PRESSION ASSOCIEE A L'ETAT STABILISE J
! IN  : MSE    : MOMENTS DUS AU SEISME
! IN  : NBTHP  : NOMBRE DE CALCULS THERMIQUE POUR L'ETAT STABILISE P
! IN  : NBTHQ  : NOMBRE DE CALCULS THERMIQUE POUR L'ETAT STABILISE Q
! IN  : IOC1   : NUMERO OCCURRENCE SITUATION DE L'ETAT STABILISE P
! IN  : IOC2   : NUMERO OCCURRENCE SITUATION DE L'ETAT STABILISE Q
! OUT : SPIJ   : AMPLITUDE DE VARIATION DES CONTRAINTES TOTALES
!     ------------------------------------------------------------------
!
    integer :: icmp, ioc1, ioc2
    real(kind=8) :: pij, d0, ep, inert, nu, e, alpha, mij, eab, xx, alphaa
    real(kind=8) :: alphab, sp1, sp2, sp3, sp4, sp5, sp6, spp, spq
! DEB ------------------------------------------------------------------
!
! --- DIFFERENCE DE PRESSION ENTRE LES ETATS I ET J
!
    pij = abs( pi - pj )
!
! --- VARIATION DE MOMENT RESULTANT
!
    mij = 0.d0
    do 10 icmp = 1, 3
        xx = mse(icmp) + abs( mi(icmp) - mj(icmp) )
        mij = mij + xx**2
10  end do
    mij = sqrt( mij )
!
! --- LE MATERIAU
!
    e = max ( mati(2) , matj(2) )
    nu = max ( mati(3) , matj(3) )
    alpha = max ( mati(4) , matj(4) )
    alphaa = max ( mati(7) , matj(7) )
    alphab = max ( mati(8) , matj(8) )
    eab = max ( mati(9) , matj(9) )
!
! --- LES CARACTERISTIQUES
!
    inert = cara(1)
    d0 = cara(2)
    ep = cara(3)
!
! CAS DE KE_MECA (PAS DE PARTITION MECANIQUE - THERMIQUE)
!
    if (typeke .lt. 0.d0) then
!
! ------ CALCUL DU SP:
!        -------------
        sp1 = k(1)*c(1)*pij*d0 / 2 / ep
        sp2 = k(2)*c(2)*d0*mij / 2 / inert
        sp3 = k(3)*e*alpha / 2 / (1.d0-nu)
!
        sp4 = k(3)*c(3)*eab
        sp5 = e*alpha / (1.d0-nu)
!
! ------ ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE P
!
        call rcsp01(nbm, ima, ipt, sp3, sp4,&
                    sp5, alphaa, alphab, nbthp, ioc1,&
                    sp6)
!
        spp = sp1 + sp2 + sp6
!
!
! ------ ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE Q
!
        call rcsp01(nbm, ima, ipt, sp3, sp4,&
                    sp5, alphaa, alphab, nbthq, ioc2,&
                    sp6)
!
        spq = sp1 + sp2 + sp6
!
        spij = max ( spp, spq )
!
! --- CAS DE KE_MIXTE (PARTITION MECANIQUE - THERMIQUE)
!
    else if (typeke.gt.0.d0) then
!
! ------ CALCUL DU SP:
!        -------------
        sp1 = k(1)*c(1)*pij*d0 / 2 / ep
        sp2 = k(2)*c(2)*d0*mij / 2 / inert
!
        spmeca=sp1+sp2
!
        sp3 = k(3)*e*alpha / 2 / (1.d0-nu)
        sp4 = k(3)*c(3)*eab
        sp5 = e*alpha / (1.d0-nu)
!
! ------ ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE P
!
        call rcsp01(nbm, ima, ipt, sp3, sp4,&
                    sp5, alphaa, alphab, nbthp, ioc1,&
                    sp6)
!
        spp = sp6
        spther = max(spther,spp)
!
! ------ ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE Q
!
        call rcsp01(nbm, ima, ipt, sp3, sp4,&
                    sp5, alphaa, alphab, nbthq, ioc2,&
                    sp6)
!
        spq = sp6
        spther = max(spther,spq)
!
    else
        call utmess('F', 'POSTRCCM_31')
!
    endif
!
end subroutine
