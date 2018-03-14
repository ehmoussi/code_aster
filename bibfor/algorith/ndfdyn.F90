! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine ndfdyn(sddyna, hval_measse, vite_curr, acce_curr, cndyna)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmhyst.h"
#include "asterfort/nminer.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
#include "asterfort/zerlag.h"
!
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_measse(*)
character(len=19), intent(in) :: vite_curr, acce_curr
character(len=19), intent(in) :: cndyna
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DES FORCES DE RAPPEL DYNAMIQUE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: amort, masse, rigid
    character(len=19) :: cniner, cnhyst
    real(kind=8) :: coerma, coeram, coerri
    aster_logical :: l_amor, l_impl
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! --- COEFFICIENTS DEVANTS MATRICES
!
    coerma = ndynre(sddyna,'COEF_FDYN_MASSE')
    coeram = ndynre(sddyna,'COEF_FDYN_AMORT')
    coerri = ndynre(sddyna,'COEF_FDYN_RIGID')
!
! --- FONCTIONNALITES ACTIVEES
!
    l_amor = ndynlo(sddyna,'MAT_AMORT')
    l_impl = ndynlo(sddyna,'IMPLICITE')
!
! --- MATRICES ASSEMBLEES
!
    call nmchex(hval_measse, 'MEASSE', 'MEAMOR', amort)
    call nmchex(hval_measse, 'MEASSE', 'MEMASS', masse)
    call nmchex(hval_measse, 'MEASSE', 'MERIGI', rigid)
!
! --- VECTEURS RESULTATS
!
    cniner = '&&CNPART.CHP1'
    cnhyst = '&&CNPART.CHP2'
    call vtzero(cniner)
    call vtzero(cnhyst)
    call vtzero(cndyna)
!
! --- VECTEURS SOLUTIONS
!
    if (l_impl) then
        call nminer(masse, acce_curr, cniner)
        call vtaxpy(coerma, cniner, cndyna)
    endif
!
    if (l_amor) then
        call nmhyst(amort, vite_curr, cnhyst)
        call vtaxpy(coeram, cnhyst, cndyna)
    endif
!
    call jedema()
end subroutine
