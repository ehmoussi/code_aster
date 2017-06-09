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

subroutine comp_meca_full(model, comp_elas, full_elem_s)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/celces.h"
#include "asterfort/cescel.h"
#include "asterfort/detrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: model
    character(len=19), intent(in) :: comp_elas
    character(len=19), intent(in) :: full_elem_s
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Create <CHELEM_S> of FULL_MECA option for checking
!
! --------------------------------------------------------------------------------------------------
!
! In  model       : name of model
! In  comp_elas   : name of ELAS <CARTE> COMPOR
! In  full_elem_s : name of <CHELEM_S> of FULL_MECA option
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbocc, ibid, iexi
    character(len=16) :: keywordfact
    character(len=19) :: elas_elem_s, elas_elem, ligrel
    aster_logical :: l_comp
!
! --------------------------------------------------------------------------------------------------
!
    nbocc = 0
    keywordfact = 'COMPORTEMENT'
    call getfac(keywordfact, nbocc)
    l_comp = nbocc .gt. 0
!
    if (l_comp) then
        ligrel = model(1:8)//'.MODELE    .LIEL'
        elas_elem_s = '&&CRCMEL.CES1'
        elas_elem = '&&CRCMEL.CEL1'
        call carces(comp_elas, 'ELEM', ' ', 'V', elas_elem_s,&
                    'A', ibid)
        call cescel(elas_elem_s, ligrel, 'FULL_MECA', 'PCOMPOR', 'OUI',&
                    ibid, 'V', elas_elem, 'A', ibid)
        call exisd('CHAMP', elas_elem, iexi)
        if (iexi .eq. 0) then
            call utmess('F', 'MECANONLINE_3')
        endif
        call celces(elas_elem, 'V', full_elem_s)
        call detrsd('CHAMP', elas_elem_s)
        call detrsd('CHAMP', elas_elem)
    endif
!
end subroutine
