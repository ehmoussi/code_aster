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

subroutine ndfdyn(sddyna, measse, vitplu, accplu, cndyna)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
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
    character(len=19) :: sddyna
    character(len=19) :: measse(*)
    character(len=19) :: vitplu, accplu
    character(len=24) :: cndyna
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DES FORCES DE RAPPEL DYNAMIQUE
!
! ----------------------------------------------------------------------
!
!
!
!
!
!
!
    character(len=19) :: amort, masse, rigid
    character(len=19) :: vites, accel
    character(len=19) :: cniner, cnhyst
    real(kind=8) :: coerma, coeram, coerri
    aster_logical :: lamor, limpl
    aster_logical :: lnewma
!
! ----------------------------------------------------------------------
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
    lamor = ndynlo(sddyna,'MAT_AMORT')
    limpl = ndynlo(sddyna,'IMPLICITE')
!
! --- TYPE DE SCHEMA: NEWMARK (ET SES DERIVEES)
!
    lnewma = ndynlo(sddyna,'FAMILLE_NEWMARK')
    if (.not.(lnewma)) then
        ASSERT(.false.)
    endif
!
! --- MATRICES ASSEMBLEES
!
    call nmchex(measse, 'MEASSE', 'MEAMOR', amort)
    call nmchex(measse, 'MEASSE', 'MEMASS', masse)
    call nmchex(measse, 'MEASSE', 'MERIGI', rigid)
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
    vites = vitplu
    accel = accplu
    if (limpl) then
        if (lnewma) then
            call nminer(masse, accel, cniner)
            call vtaxpy(coerma, cniner, cndyna)
        else
            ASSERT(.false.)
        endif
    endif
!
    if (lamor) then
        call nmhyst(amort, vites, cnhyst)
        call vtaxpy(coeram, cnhyst, cndyna)
    endif
!
    call jedema()
end subroutine
