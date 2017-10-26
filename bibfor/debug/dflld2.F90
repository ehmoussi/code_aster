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
!
subroutine dflld2(sdlist, i_fail)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: sdlist
integer, intent(in) :: i_fail
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Print for time step cutting
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of DEFI_LIST_INST datastructure
! In  i_fail           : current event
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdlist_esubdr
    real(kind=8), pointer :: v_sdlist_esubdr(:) => null()
    character(len=24) :: sdlist_linfor
    real(kind=8), pointer :: v_sdlist_linfor(:) => null()
    real(kind=8) :: subd_pas_mini, subd_inst, subd_duree
    integer :: subd_niveau, subd_pas, subd_auto
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to datastructures
!
    sdlist_linfor = sdlist(1:8)//'.LIST.INFOR'
    call jeveuo(sdlist_linfor, 'L', vr = v_sdlist_linfor)
    sdlist_esubdr = sdlist(1:8)//'.ECHE.SUBDR'
    call jeveuo(sdlist_esubdr, 'L', vr = v_sdlist_esubdr)
!
! - Print
!
    subd_pas      = nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+2))
    subd_pas_mini = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+3)
    subd_niveau   = nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+4))
    subd_inst     = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+5)
    subd_duree    = v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+6)
    subd_auto     = nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+10))
    if (nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+1)) .eq. 1) then
        call utmess('I', 'DISCRETISATION3_60')
        if (subd_niveau .eq. 0) then
            call utmess('I', 'DISCRETISATION3_61', si = subd_pas, sr = subd_pas_mini)
        else
            call utmess('I', 'DISCRETISATION3_62', ni = 2, vali = [subd_pas, subd_niveau])
        endif
    else if (nint(v_sdlist_esubdr(SIZE_LESUR*(i_fail-1)+1)) .eq. 2) then
        if (subd_auto .eq. 2) then
            call utmess('I', 'DISCRETISATION3_70')
        else if (subd_auto .eq. 1) then
            call utmess('I', 'DISCRETISATION3_71')
            call utmess('I', 'DISCRETISATION3_72', nr=2, valr = [subd_inst, subd_duree])
        endif
    endif
!
    call jedema()
end subroutine
