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

subroutine rc36sn(nbm, adrm, ipt, c, cara,&
                  mati, pi, mi, matj, pj,&
                  mj, mse, nbthp, nbthq, ioc1,&
                  ioc2, snij)
    implicit   none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rcsn01.h"
    integer :: nbm, adrm(*), ipt, nbthp, nbthq
    real(kind=8) :: c(*), cara(*), mati(*), matj(*), pi, mi(*), pj, mj(*)
    real(kind=8) :: mse(*), snij
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!     CALCUL DU SN
!
! IN  : ADRM   : NUMEROS DE LA MAILLE TRAITEE
!                ET DE LA MAILLE CONNEXE EN IPT
! IN  : IPT    : NUMERO DU NOEUD TRAITE
! IN  : C      : INDICES DE CONTRAINTES
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
! OUT : SNIJ   : AMPLITUDE DE VARIATION DES CONTRAINTES LINEARISEES
!     ------------------------------------------------------------------
!
    integer :: icmp, ioc1, ioc2
    real(kind=8) :: pij, d0, ep, inert, nu, e, alpha, mij, eab, xx, alphaa
    real(kind=8) :: alphab, sn1, sn2, sn3, sn4, sn6, snp, snq
! DEB ------------------------------------------------------------------
    call jemarq()
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
! --- CALCUL DU SN:
!     -------------
!
    sn1 = c(1)*pij*d0 / 2 / ep
    sn2 = c(2)*d0*mij / 2 / inert
    sn3 = e*alpha / 2 / (1.d0-nu)
    sn4 = c(3)*eab
!
! --- ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE P
!
    call rcsn01(nbm, adrm, ipt, sn3, sn4,&
                alphaa, alphab, nbthp, ioc1, sn6)
!
    snp = sn1 + sn2 + sn6
!
    snij = max ( snij, snp )
!
! --- ON BOUCLE SUR LES INSTANTS DU THERMIQUE DE Q
!
    call rcsn01(nbm, adrm, ipt, sn3, sn4,&
                alphaa, alphab, nbthq, ioc2, sn6)
!
    snq = sn1 + sn2 + sn6
!
    snij = max ( snij, snq )
!
    call jedema()
end subroutine
