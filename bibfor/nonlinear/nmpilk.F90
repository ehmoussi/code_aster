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

subroutine nmpilk(incpr1, incpr2, ddincc, neq, eta,&
                  rho, offset)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: neq
    real(kind=8) :: eta, rho, offset
    character(len=19) :: incpr1, incpr2, ddincc
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! AJUSTEMENT DE LA DIRECTION DE DESCENTE
!
! ----------------------------------------------------------------------
!
! CORR = RHO * PRED(1) + (ETA-OFFSET) * PRED(2)
!
! IN  NEQ    : LONGUEUR DES CHAM_NO
! IN  INCPR1 : INCREMENT SOLUTION PHASE PREDICTION 1
! IN  INCPR2 : INCREMENT SOLUTION PHASE PREDICTION 2 (TERME PILOTAGE)
! OUT DDINNC : INCREMENT SOLUTION APRES PILOTAGE/RECH. LINE.
! IN  ETA    : PARAMETRE DE PILOTAGE
! IN  RHO    : PARAMETRE DE RECHERCHE LINEAIRE
! IN  OFFSET : DECALAGE DU PARMAETRE DE PILOTAGE
!
!
!
!
    integer :: i
    real(kind=8), pointer :: ddepl(:) => null()
    real(kind=8), pointer :: du0(:) => null()
    real(kind=8), pointer :: du1(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call jeveuo(incpr1(1:19)//'.VALE', 'L', vr=du0)
    call jeveuo(incpr2(1:19)//'.VALE', 'L', vr=du1)
    call jeveuo(ddincc(1:19)//'.VALE', 'E', vr=ddepl)
!
! --- CALCUL
!
    do 10 i = 1, neq
        ddepl(i) = rho*du0(i) + (eta-offset)*du1(i)
10  end do
!
    call jedema()
end subroutine
