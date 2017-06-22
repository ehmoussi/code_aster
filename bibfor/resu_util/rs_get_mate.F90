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

subroutine rs_get_mate(result_, nume, chmate, codret)
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
    character(len=*), intent(out) :: chmate
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get material field at index stored in results datastructure or from command file
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nume             : index to find in results datastructure
! Out chmate           : name of material characteristics (field)
! Out codret           : return code
!                        -1 - No mate found
!                         1 - Material from command file
!                         2 - Material from results datastructure
!                         3 - Material from results datastructure and command file (the same)
!                         4 - Material from command file is different from results datastructure
!                        
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result, chmate_resu, chmate_comm
    integer :: nocc, jv_para
!
! --------------------------------------------------------------------------------------------------
!
    result = result_
    chmate = ' '
    nocc   = 0
    codret = -1
!
! - Get from command file
!
    chmate_comm = ' '
    if (getexm(' ','CHAM_MATER') .eq. 1) then
        call getvid(' ', 'CHAM_MATER', scal=chmate_comm, nbret=nocc)
    else
        chmate_comm = ' '
        nocc        = 0
    endif
!
! - Get from results datastructure
!
    chmate_resu = ' '
    call rsadpa(result, 'L', 1, 'CHAMPMAT', nume, 0, sjv=jv_para)
    chmate_resu = zk8(jv_para)
!
! - Select material field
!
    if (chmate_resu .eq. ' ') then
        if (nocc .eq. 0) then
            chmate = ' '
            codret = -1
        else
            chmate = chmate_comm
            codret = 1
        endif
    else
        if (nocc .eq. 0) then
            chmate = chmate_resu
            codret = 2
        else if (chmate_resu .eq. chmate_comm) then
            chmate = chmate_comm
            codret = 3
        else
            chmate = chmate_comm
            codret = 4
        endif
    endif
!
end subroutine
