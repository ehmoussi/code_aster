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

subroutine nmincr(sddyna, ddincr, coedep, coevit, coeacc,&
                  dddepl, ddvite, ddacce)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
    character(len=19) :: sddyna
    real(kind=8) :: coedep, coevit, coeacc
    character(len=19) :: ddincr
    character(len=19) :: dddepl, ddvite, ddacce
!
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CONVERSION INCREMENT dINCR VENANT DE K.dINCR = F EN
! dU,dV,dA  SUIVANT SCHEMAS
!
! ----------------------------------------------------------------------
!
! dU = COEDEP.DINCR
! dV = COEVIT.DINCR
! dA = COEACC.DINCR
!
! EN EXPLICITE PURE, CE NE SONT PAS DES INCREMENTS MAIS DIRECTEMENT
! LA SOLUTION EN N+1
!
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  DDINCR : INCREMENT SOLUTION DE K.DDINCR = F
! IN  COEDEP : COEF. POUR INCREMENT DEPLACEMENT
! IN  COEVIT : COEF. POUR INCREMENT VITESSE
! IN  COEACC : COEF. POUR INCREMENT ACCELERATION
! OUT DDDEPL : INCREMENT DEPLACEMENT
! OUT DDVITE : INCREMENT VITESSE
! OUT DDACCE : INCREMENT ACCELERATION
!
!
!
!
    aster_logical :: lstat, ldyna
    aster_logical :: ldepl, lvite, lacce
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    lstat = ndynlo(sddyna,'STATIQUE')
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
!
! --- TYPE DE FORMULATION SCHEMA DYNAMIQUE GENERAL
!
    if (lstat) then
        ldepl = .true.
        lvite = .false.
        lacce = .false.
    else if (ldyna) then
        ldepl = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
        lvite = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
        lacce = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL DES INCREMENTS
!
    if (ldepl) then
        call copisd('CHAMP_GD', 'V', ddincr, dddepl)
        if (coevit .ne. 0.d0) then
            call vtzero(ddvite)
            call vtaxpy(coevit, ddincr, ddvite)
        endif
        if (coeacc .ne. 0.d0) then
            call vtzero(ddacce)
            call vtaxpy(coeacc, ddincr, ddacce)
        endif
    else if (lvite) then
        call copisd('CHAMP_GD', 'V', ddincr, ddvite)
        call vtzero(dddepl)
        call vtzero(ddacce)
        call vtaxpy(coedep, ddincr, dddepl)
        call vtaxpy(coeacc, ddincr, ddacce)
!
    else if (lacce) then
        call copisd('CHAMP_GD', 'V', ddincr, ddacce)
        call vtzero(dddepl)
        call vtzero(ddvite)
        call vtaxpy(coedep, ddincr, dddepl)
        call vtaxpy(coevit, ddincr, ddvite)
!
    else
        ASSERT(.false.)
    endif
!
!
    call jedema()
end subroutine
