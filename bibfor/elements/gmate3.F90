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

subroutine gmate3(abscur, elrefe, conn, nno, mele)

implicit none

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrfvf.h"
#include "asterfort/elrfdf.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"

    integer           :: conn(3)
    integer           :: nno
    real(kind=8)      :: mele(3, 3)
    character(len=8)  :: elrefe
    character(len=24) :: abscur

!      CALCUL DE LA MATRICE ELEMENTAIRE POUR L'ELEMENT COURANT
!      METHODE THETA-LAGRANGE ET G-LAGRANGE
!
! ENTREE
!   CONN     --> CONNECTIVITÉ DES NOEUDS
!   ELREFE   --> TYPE DE SEGMENT (LINEAIRE OU QUADRATIQUE)   
!   ABSCUR   --> ABSCISSES CURVILIGNES S
!
! SORTIE
!   NNO      --> DIMMENSION DE LA MATRICE ELEMENTAIRE
!   MELE     --> MATRICE DE MASSE ELEMENTAIRE
!
! ......................................................................

    integer, parameter :: npg = 14, nbnomx = 3
    integer            :: i, j, ipg, js, ndim
    real(kind=8)       :: xpg(npg), wpg(npg)
    real(kind=8)       :: ff(nbnomx), dff(3, nbnomx)
    real(kind=8)       :: ksi(1), jac

! ......................................................................

!   COOR ET POID DU POINT DE GAUSS

        data xpg /-.1080549487073437,&
     &             .1080549487073437,&
     &            -.3191123689278897,&
     &             .3191123689278897,&
     &            -.5152486363581541,&
     &             .5152486363581541,&
     &            -.6872929048116855,&
     &             .6872929048116855,&
     &            -.8272013150697650,&
     &             .8272013150697650,&
     &            -.9284348836635735,&
     &             .9284348836635735,&
     &            -.9862838086968123,&
     &             .9862838086968123/
!
! VALEURS DES POIDS ASSOCIES
!
    data wpg /    .2152638534631578,&
     &            .2152638534631578,&
     &            .2051984637212956,&
     &            .2051984637212956,&
     &            .1855383974779378,&
     &            .1855383974779378,&
     &            .1572031671581935,&
     &            .1572031671581935,&
     &            .1215185706879032,&
     &            .1215185706879032,&
     &            .0801580871597602,&
     &            .0801580871597602,&
     &            .0351194603317519,&
     &            .0351194603317519/

! ......................................................................
    call jemarq()

    mele = 0.d0

!   BOUCLE SUR LE SEGMENT DU FONDFISS
    call jeveuo(abscur, 'L', js)

!   BOUCLE SUR LES POINTS DE GAUSS DU SEGMENT
    do ipg = 1, npg

!       CALCUL DES FONCTIONS DE FORMES ET DERIVEES
        ksi(1)=xpg(ipg)
        call elrfvf(elrefe, ksi, nbnomx, ff, nno)
        call elrfdf(elrefe, ksi, 3*nbnomx, dff, nno, ndim)
        
!       CALCUL DU JACOBIEN (SEGM DE REFERENCE --> SEGM REEL)
        jac = 0.5d0*(zr(js-1+conn(2)) - zr(js-1+conn(1)))

!       CONTRIBUTION DU POINT DE GAUSS A LA MATRICE ELEMENTAIRE   
        do i = 1, nno
            do j = 1, nno
               mele(i, j) = mele(i, j) + ff(i)*ff(j)*jac*wpg(ipg)
            end do
        end do
!
    end do

    call jedema()

end subroutine
