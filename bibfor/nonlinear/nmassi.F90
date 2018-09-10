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
subroutine nmassi(list_func_acti, sddyna, hval_veasse, cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmacfi.h"
#include "asterfort/nmacva.h"
#include "asterfort/nmdebg.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_veasse(*)
character(len=19), intent(in) :: cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for initial acceleration
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndonn           : name of nodal field for "given" forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cndfdo, cnfvdo
    aster_logical :: l_wave, l_lapl
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_17')
    endif
!
! - Active functionnalities
!
    l_wave = ndynlo(sddyna,'ONDE_PLANE')
    l_lapl = isfonc(list_func_acti,'LAPLACE')
    if (l_wave .or. l_lapl) then
        call utmess('A', 'MECANONLINE_23')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
!
! - Get Dirichlet boundary conditions - B.U
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNBUDI', -1.d0, ds_vectcomb)
!
! - Get Neumann and Dirichlet loads
!
    call nmacfi(list_func_acti, hval_veasse, cnffdo, cndfdo)
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Get variables loads
!
    call nmacva(hval_veasse, cnfvdo)
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Add internal forces to second member
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFNOD', -1.d0, ds_vectcomb)
!
! - Second member (standard)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
    if (niv .ge. 2) then
        call nmdebg('VECT', cndonn, 6)
    endif
!
end subroutine
