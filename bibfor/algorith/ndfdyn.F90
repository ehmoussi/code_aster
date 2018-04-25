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
subroutine ndfdyn(sddyna, hval_measse, ds_measure, vite_curr, acce_curr,&
                  cndyna)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmhyst.h"
#include "asterfort/nminer.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
!
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_measse(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: vite_curr, acce_curr
character(len=19), intent(in) :: cndyna
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! CALCUL DES FORCES DE RAPPEL DYNAMIQUE
!
! --------------------------------------------------------------------------------------------------
!
! In  sddyna           : datastructure for dynamic
! In  hval_measse      : hat-variable for matrix
! IO  ds_measure       : datastructure for measure and statistics management
! In  vite_curr        : speed field
! In  acce_curr        : acceleration field
! In  cndyna           : name of dynamic effect on second member
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: amort, masse
    character(len=19) :: cniner, cnhyst
    real(kind=8) :: coerma, coeram
    aster_logical :: l_amor, l_impl
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_9')
    endif
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! --- COEFFICIENTS DEVANTS MATRICES
!
    coerma = ndynre(sddyna,'COEF_FDYN_MASSE')
    coeram = ndynre(sddyna,'COEF_FDYN_AMORT')
!
! - Active functionnalities
!
    l_amor = ndynlo(sddyna,'MAT_AMORT')
    l_impl = ndynlo(sddyna,'IMPLICITE')
!
! --- MATRICES ASSEMBLEES
!
    call nmchex(hval_measse, 'MEASSE', 'MEAMOR', amort)
    call nmchex(hval_measse, 'MEASSE', 'MEMASS', masse)
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
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! - Debug
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cndyna, 6)
    endif
!
end subroutine
