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
subroutine nonlinDSDynamicInit(hval_incr, sddyna)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/ndynlo.h"
#include "asterfort/getvid.h"
#include "asterfort/mginfo.h"
#include "asterfort/nmchex.h"
#include "asterfort/dismoi.h"
#include "asterfort/iden_nume.h" 
!
character(len=19), intent(in) :: hval_incr(*)
character(len=19), intent(in) :: sddyna
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Dynamic management
!
! Initializations for dynamic
!
! --------------------------------------------------------------------------------------------------
!
! In  hval_incr        : hat-variable for incremental values fields
! In  sddyna           : datastructure for dynamic
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbmd, nb_mode, nb_equa
    aster_logical :: l_damp_moda
    character(len=19) :: pfcn1, pfcn2, disp_prev
    character(len=8) :: mode_meca
    character(len=14) :: nume_ddl
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_13')
    endif
!
! - Active functionnalities
!
    l_damp_moda = ndynlo(sddyna,'AMOR_MODAL')
!
! - Modal damping
!
    if (l_damp_moda) then
        call getvid('AMOR_MODAL', 'MODE_MECA', iocc=1, scal=mode_meca, nbret=nbmd)
        call mginfo(mode_meca, nume_ddl, nb_mode, nb_equa)
        call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
        call dismoi('PROF_CHNO', disp_prev, 'CHAM_NO', repk=pfcn1)
        call dismoi('PROF_CHNO', nume_ddl, 'NUME_DDL', repk=pfcn2)
        if (.not.iden_nume(pfcn1, pfcn2)) then
            call utmess('F', 'DYNAMIQUE_54')
        endif
    endif
!
end subroutine
