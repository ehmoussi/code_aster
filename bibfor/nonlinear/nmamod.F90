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

subroutine nmamod(phase, numedd, sddyna, vitplu, vitkm1,&
                  cnamom)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/fmodam.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynkk.h"
#include "asterfort/ndynlo.h"
    character(len=4) :: phase
    character(len=19) :: vitplu, vitkm1
    character(len=19) :: sddyna
    character(len=24) :: numedd, cnamom
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DES FORCES D'AMORTISSEMENT MODAL
!
! ----------------------------------------------------------------------
!
!
! IN  PHASE  : PHASE DE CALCUL (PREDICTION OU CORRECTION)
! IN  VITPLU : VITESSE COURANTE
! IN  VITKM1 : VITESSE ITERATION NEWTON PRECEDENTE
! IN  NUMEDD : NUME_DDL
! IN  SDDYNA : SD DYNAMIQUE
! OUT CNAMOM : VECT_ASSE FORCES AMORTISSEMENT MODAL
!
!
!
!
    integer :: jmoda
    character(len=24) :: valmod, basmod
    character(len=19) :: sdammo
    aster_logical :: nreavi
    integer :: neq
    real(kind=8), pointer :: vitkm(:) => null()
    real(kind=8), pointer :: vitp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
    call ndynkk(sddyna, 'SDAMMO', sdammo)
    valmod = sdammo(1:19)//'.VALM'
    basmod = sdammo(1:19)//'.BASM'
    nreavi = ndynlo(sddyna,'NREAVI')
!
! --- ACCES OBJETS JEVEUX
!
    call jeveuo(vitplu(1:19)//'.VALE', 'L', vr=vitp)
    call jeveuo(vitkm1(1:19)//'.VALE', 'L', vr=vitkm)
    call jeveuo(cnamom(1:19)//'.VALE', 'E', jmoda)
!
! --- CALCUL FORCES MODALES
!
    if (phase .eq. 'PRED') then
        call fmodam(neq, vitkm, valmod, basmod, zr(jmoda))
    else if (phase.eq.'CORR') then
        call fmodam(neq, vitp, valmod, basmod, zr(jmoda))
        if (nreavi) then
            call fmodam(neq, vitp, valmod, basmod, zr(jmoda))
        endif
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
