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

subroutine rs_get_caraelem(result_, nume, cara_elem, codret)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/getvid.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    integer, intent(in) :: nume
    character(len=*), intent(out) :: cara_elem
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get elementary characteristics at index stored in results datastructure or from command file
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nume             : index to find in results datastructure
! Out cara_elem        : name of elementary characteristics (field)
! Out codret           : return code
!                        -1 - No cara_elem found
!                         1 - Cara_elem from command file
!                         2 - Cara_elem from results datastructure
!                         3 - Cara_elem from results datastructure and command file (the same)
!                         4 - Cara_elem from command file is different from results datastructure
!                        
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result, cara_elem_resu, cara_elem_comm
    integer :: nocc, jv_para
!
! --------------------------------------------------------------------------------------------------
!
    result     = result_
    cara_elem  = ' '
    nocc       = 0
    codret     = -1
!
! - Get from command file
!
    cara_elem_comm = ' '
    if (getexm(' ','CARA_ELEM') .eq. 1) then
        call getvid(' ', 'CARA_ELEM', scal=cara_elem_comm, nbret=nocc)
    else
        cara_elem_comm = ' '
        nocc           = 0
    endif
!
! - Get from results datastructure
!
    cara_elem_resu = ' '
    call rsadpa(result, 'L', 1, 'CARAELEM', nume,&
                0, sjv=jv_para)
    cara_elem_resu = zk8(jv_para)
!
! - Select cara_elem
!
    if (cara_elem_resu .eq. ' ') then
        if (nocc .eq. 0) then
            cara_elem  = ' '
            codret     = -1
        else
            cara_elem  = cara_elem_comm
            codret     = 1
        endif
    else
        if (nocc .eq. 0) then
            cara_elem  = cara_elem_resu
            codret     = 2
        else if (cara_elem_resu .eq. cara_elem_comm) then
            cara_elem  = cara_elem_comm
            codret     = 3
        else
            cara_elem  = cara_elem_comm
            codret     = 4
        endif
    endif
!
end subroutine
