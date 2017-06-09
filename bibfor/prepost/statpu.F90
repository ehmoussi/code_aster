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

subroutine statpu(nbobst, nbpt, temps, fcho, vgli,&
                  iadh, wk1, wk2, wk3, iwk4,&
                  idebut, nbloc, nbval, ifires, inoe,&
                  impr, pusurn)
!     CALCUL DE LA PUISSANCE D'USURE AU SENS D'ARCHARD
!
! IN  : NBOBST : NB DE NOEUDS DE CHOC
! IN  : NBPT   : NB DE PAS DE TEMPS TEMPORELS ARCHIVES
! IN  : TEMPS  : INSTANTS DE CALCUL
! IN  : FCHO   : VECTEUR DES FORCES DE CHOC
! IN  : VGLI   : VECTEUR DES VITESSES DE GLISSEMENT
! IN  : NBLOC  : NB DE BLOCS POUR LE MOYENNAGE
! IN  : INOE   : NUMERO DE NOEUD TRAITE
! IN  : IMPR   : IMPRESSION
! OUT : PUSURN : PUISSANCE D'USURE MOYENNEE
!-----------------------------------------------------------------------
    implicit none
#include "asterfort/impus.h"
#include "asterfort/pusure.h"
#include "blas/dcopy.h"
    real(kind=8) :: temps(*), fcho(*), vgli(*), wk1(*), wk2(*), wk3(*)
    integer :: iwk4(*), iadh(*)
!
!-----------------------------------------------------------------------
    integer :: i, ibl, idebut, ifires, impr, inoe, nbloc
    integer :: nbobst, nbpt, nbval
    real(kind=8) :: pusee, pusurn
!-----------------------------------------------------------------------
    pusurn = 0.d0
    call dcopy(nbpt, fcho(3*(inoe-1)+1), 3*nbobst, wk1, 1)
    call dcopy(nbpt, vgli(3*(inoe-1)+2), 3*nbobst, wk2, 1)
    call dcopy(nbpt, vgli(3*(inoe-1)+3), 3*nbobst, wk3, 1)
!     CALL DCOPY(NBPT,IADH(1*(INOE-1)+1),NBOBST,IWK4,1)
    do 5 i = 1, nbpt
        iwk4(i) = iadh(1*(inoe-1)+1+(i-1)*nbobst)
 5  end do
    do 10 ibl = 1, nbloc
        call pusure(nbval, wk1((ibl-1)*nbval+idebut), wk2((ibl-1)* nbval+idebut),&
                    wk3((ibl-1)*nbval+idebut), iwk4((ibl-1)*nbval+ idebut),&
                    temps((ibl-1)*nbval+idebut), pusee)
        pusurn = pusurn + pusee
!C       --- IMPRESSION DE LA PUISSANCE D USURE ---
        if (impr .eq. 2) call impus(ifires, ibl, pusee)
10  end do
    pusurn = pusurn / nbloc
    if (ibl .gt. 1 .and. impr .eq. 2) call impus(ifires, 0, pusurn)
!
end subroutine
