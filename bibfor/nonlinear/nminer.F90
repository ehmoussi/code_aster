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

subroutine nminer(masse, accplu, cniner)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
    character(len=19) :: masse
    character(len=19) :: accplu, cniner
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DES FORCES D'INERTIE
!
! ----------------------------------------------------------------------
!
!
! IN  ACCPLU : ACCELERATION COURANTE
! IN  MASSE  : MATR_ASSE MASSE
! OUT CNINER : VECT_ASSE FORCES INERTIE
!
!
!
!
    integer ::  jmass
    real(kind=8), pointer :: accp(:) => null()
    real(kind=8), pointer :: iner(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES OBJETS JEVEUX
!
    call jeveuo(accplu(1:19)//'.VALE', 'L', vr=accp)
    call jeveuo(masse(1:19) //'.&INT', 'L', jmass)
    call jeveuo(cniner(1:19)//'.VALE', 'E', vr=iner)
!
! --- CALCUL FORCES INERTIE
!
    call mrmult('ZERO', jmass, accp, iner, 1,&
                .true._1)
!
    call jedema()
end subroutine
