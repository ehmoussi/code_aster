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

subroutine lcloca(coeft,nmat, nbcomm,&
                  nphas, sigi, vini, iphas, granb,&
                  loca, sigg)
!

    implicit none
#include "asterc/r8miem.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcnrts.h"
#include "asterfort/utmess.h"
    integer :: nphas, nmat, nbcomm(nmat, 3), iphas
    real(kind=8) :: vini(*), coeft(nmat)
    real(kind=8) :: sigi(6), alpha, sigg(6)
    character(len=16) :: loca
    real(kind=8) :: mu, dev(6), norme, evpcum, granb(6)
    integer :: ievpg, i
! person_in_charge: jean-michel.proix at edf.fr
! ======================================================================
!       in
!           coeft    :  coef materiau
!           nmat     :  nombre  maxi de coef materiau
!           nbcomm   :  nombre de coef materiau par famille
!           nphas    :  nombre de phases
!           sigi     :  contraintes a l'instant courant
!           vini     :  variables internes a t
!           iphas    :  phase courante
!           granb    :  variables internes pour la règle en Beta
!           loca     :  nom de la règle de localisation
!     out:
!           sigg    : tenseur des contraintes pour la phase iphas
! integration des lois polycristallines par une methode de runge kutta
!
!     cette routine permet d'appliquer la methode de localisation
!
!     7 variables : tenseur EVP + Norme(EVP)
!    description des variables internes :
!    pour chaque phase
!        6 variables : beta ou epsilonp par phase
!    pour chaque phase
!        pour chaque systeme de glissement
!              3 variables Alpha, Gamma, P
!    1 variable : indic
! ======================================================================
!
    mu=coeft(nbcomm((nphas+2),1)+0)
!
! --  METHODE LOCALISATION
    if (loca .eq. 'BZ') then
        call lcdevi(sigi, dev)
        norme = lcnrts( dev )
        evpcum=vini(7)
        if (norme .gt. r8miem()) then
            alpha=norme/(norme+1.5d0*mu*evpcum)
        else
            alpha=0.d0
        endif
!        EVP - EVPG(IPHAS)
        ievpg=7+6*(iphas-1)
        do 1 i = 1, 6
            sigg(i)=sigi(i)+alpha*mu*(vini(i)-vini(ievpg+i))
 1      continue
!
    else if (loca.eq.'BETA') then
!        EVP - EVPG(IPHAS)
        ievpg=7+6*(iphas-1)
        do 2 i = 1, 6
            sigg(i)=sigi(i)+mu*(granb(i)-vini(ievpg+i))
 2      continue
!
!
    else
        call utmess('F', 'ALGORITH4_63', sk=loca)
    endif
end subroutine
