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

subroutine varc_prep(chmate, l_thm)
!
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_, ca_ctempr_, ca_ctempm_, ca_ctempp_
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/ismaem.h"
#include "asterc/r8nnem.h"
#include "asterc/indik8.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveut.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: chmate
    aster_logical, intent(in) :: l_thm
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Preparation (for calcul_module)
!
! --------------------------------------------------------------------------------------------------
!
! In  chmate           : name of material field (CHAM_MATER)
! In  l_thm            : .true. if THM
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, varc_indx
    character(len=8) :: varc_name
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    varc_name = 'TEMP'
!
    call jeexin(chmate//'.CVRCNOM', iret)
    if (iret .ne. 0) then
        call jeveut(chmate//'.CVRCNOM', 'L', ca_jvcnom_)
        call jelira(chmate//'.CVRCNOM', 'LONMAX', ca_nbcvrc_)
    else
        ca_nbcvrc_ = 0
        ca_jvcnom_ = ismaem()
    endif
!
! - For coupled problems (THM)
!
    if (l_thm) then
        if (ca_nbcvrc_ .eq. 0) then
            ca_ctempr_ = r8nnem()
            ca_ctempm_ = r8nnem()
            ca_ctempp_ = r8nnem()
        else
            varc_indx = indik8(zk8(ca_jvcnom_), varc_name, 1, ca_nbcvrc_)
            if (varc_indx .ne. 0) then
                call utmess('F', 'MATERIAL2_51')
            endif
            ca_ctempr_ = r8nnem()
            ca_ctempm_ = r8nnem()
            ca_ctempp_ = r8nnem()
        endif
    endif
!
    call jedema()
end subroutine
