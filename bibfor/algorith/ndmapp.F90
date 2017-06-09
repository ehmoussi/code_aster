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

subroutine ndmapp(sddyna, valinc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynkk.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
    character(len=19) :: valinc(*)
    character(len=19) :: sddyna
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! MISE A JOUR DES CHAMPS MULTI-APPUI
!
! ----------------------------------------------------------------------
!
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
!
!
!
!
    aster_logical :: lmuap
    character(len=19) :: depplu, vitplu, accplu
    character(len=19) :: depent, vitent, accent
    character(len=19) :: depabs, vitabs, accabs
    integer :: neq, ie
    real(kind=8), pointer :: accab(:) => null()
    real(kind=8), pointer :: accen(:) => null()
    real(kind=8), pointer :: accp(:) => null()
    real(kind=8), pointer :: depab(:) => null()
    real(kind=8), pointer :: depen(:) => null()
    real(kind=8), pointer :: depp(:) => null()
    real(kind=8), pointer :: vitab(:) => null()
    real(kind=8), pointer :: viten(:) => null()
    real(kind=8), pointer :: vitp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    lmuap = ndynlo(sddyna,'MULTI_APPUI')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call nmchex(valinc, 'VALINC', 'VITPLU', vitplu)
    call nmchex(valinc, 'VALINC', 'ACCPLU', accplu)
!
! --- CALCUL DES DEPL/VITE/ACCE ABSOLU EN MULTI-APPUIS
!
    if (lmuap) then
        call ndynkk(sddyna, 'DEPENT', depent)
        call ndynkk(sddyna, 'VITENT', vitent)
        call ndynkk(sddyna, 'ACCENT', accent)
        call ndynkk(sddyna, 'DEPABS', depabs)
        call ndynkk(sddyna, 'VITABS', vitabs)
        call ndynkk(sddyna, 'ACCABS', accabs)
        call jeveuo(depent(1:19)//'.VALE', 'L', vr=depen)
        call jeveuo(vitent(1:19)//'.VALE', 'L', vr=viten)
        call jeveuo(accent(1:19)//'.VALE', 'L', vr=accen)
        call jeveuo(depplu(1:19)//'.VALE', 'L', vr=depp)
        call jeveuo(vitplu(1:19)//'.VALE', 'L', vr=vitp)
        call jeveuo(accplu(1:19)//'.VALE', 'L', vr=accp)
        call jeveuo(depabs(1:19)//'.VALE', 'E', vr=depab)
        call jeveuo(vitabs(1:19)//'.VALE', 'E', vr=vitab)
        call jeveuo(accabs(1:19)//'.VALE', 'E', vr=accab)
        call jelira(depent(1:19)//'.VALE', 'LONMAX', neq)
        do 20 ie = 1, neq
            depab(ie) = depen(ie) + depp(ie)
            vitab(ie) = viten(ie) + vitp(ie)
            accab(ie) = accen(ie) + accp(ie)
 20     continue
    endif
!
    call jedema()
!
end subroutine
