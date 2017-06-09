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

subroutine gmeth2(nnoff, ndeg, gthi, gs, objcur, xl, gi, norfon)

implicit none

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/glegen.h"
#include "asterfort/gmatr2.h"
#include "asterfort/gsyste.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"

    integer           :: nnoff, ndeg
    real(kind=8)      :: gthi(1), gs(1), gi(1), xl
    character(len=24) :: objcur, norfon

!      METHODE THETA-LAGRANGE ET G-LEGENDRE POUR LE CALCUL DE G(S)
!
! ENTREE
!
!     NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
!     NDEG     --> DEGRE DES POLYNOMES DE LEGENDRE
!     XL       --> LONGUEUR DE LA FISSURE
!     GTHI     --> VALEURS DE G POUR LES CHAMPS THETAI
!     OBJCUR   --> ABSCISSES CURVILIGNES S
!     NORFON   --> NORMALE AU FOND DE FISSURE
!  SORTIE
!
!      GS      --> VALEUR DE G(S)
!      GI      --> VALEUR DE GI
!......................................................................

    integer           :: iadrt3, i, j
    real(kind=8)      :: som
    character(len=24) :: matr

!......................................................................
    call jemarq()
!
!   VALEURS DES POLYNOMES DE LEGENDRE POUR LES NOEUDS DU FOND DE FISSURE
    call wkvect('&&METHO2.THETA', 'V V R8', (ndeg+1)*nnoff, iadrt3)
    call glegen(ndeg, nnoff, xl, objcur, zr(iadrt3))
!    
!   CALCUL DE LA MATRICE DU SYSTEME LINÉAIRE [A] {GI} = {GTHI}
    matr = '&&METHO2.MATRIC'
    call gmatr2(nnoff, ndeg, objcur, xl, matr, norfon)
!
!   RESOLUTION DU SYSTEME LINEAIRE:  MATR*GI = GTHI
    call gsyste(matr, ndeg+1, nnoff, gthi, gi)
!
!   CALCUL DE G(S)
    do i = 1, nnoff
        som = 0.d0
        do j = 1, ndeg+1
            som = som + gi(j)*zr(iadrt3+(j-1)*nnoff+i-1)
        end do
        gs(i) = som
    enddo
!
!   DESTRUCTION DES OBJETS DE TRAVAIL
    call jedetr('&&METHO2.THETA')
    call jedetr('&&METHO2.MATRIC')
!
    call jedema()
end subroutine
