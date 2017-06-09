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

subroutine nmrecz(numedd, cndiri, cnfint, cnfext, ddepla,&
                  fonc)
!
! person_in_charge: mickael.abbas at edf.fr
!
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    real(kind=8) :: fonc
    character(len=24) :: numedd
    character(len=19) :: cndiri, cnfint, cnfext, ddepla
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECHERCHE LINEAIRE)
!
! CALCUL DE LA FONCTION POUR LA RECHERCHE LINEAIRE
!
! ----------------------------------------------------------------------
!
!
! IN  NUMEDD : NOM DU NUME_DDL
! IN  CNDIRI : VECT_ASSE REACTIONS D'APPUI
! IN  CNFINT : VECT_ASSE FORCES INTERIEURES
! IN  CNFEXT : VECT_ASSE FORCES EXTERIEURES
! IN  DDEPLA : INCREMENT DE DEPLACEMENT
! OUT FONC   : VALEUR DE LA FONCTION
!
!
!
!
    integer :: ieq, neq
    real(kind=8), pointer :: ddepl(:) => null()
    real(kind=8), pointer :: diri(:) => null()
    real(kind=8), pointer :: fext(:) => null()
    real(kind=8), pointer :: fint(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
! --- ACCES OBJETS
!
    call jeveuo(cnfext(1:19)//'.VALE', 'L', vr=fext)
    call jeveuo(cnfint(1:19)//'.VALE', 'L', vr=fint)
    call jeveuo(cndiri(1:19)//'.VALE', 'L', vr=diri)
    call jeveuo(ddepla(1:19)//'.VALE', 'L', vr=ddepl)
!
    fonc = 0.d0
    do ieq = 1, neq
        fonc = fonc + ddepl(ieq) * (fint(ieq)+ diri(ieq)- fext(ieq))
    end do
!
    call jedema()
end subroutine
