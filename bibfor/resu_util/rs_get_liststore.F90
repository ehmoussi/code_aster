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

subroutine rs_get_liststore(result_, nb_store, v_list_store_)
!
implicit none
!
#include "asterfort/rsorac.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    integer, intent(out) :: nb_store
    integer, pointer, optional :: v_list_store_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get list of storing index in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! Out nb_store         : number of storing index in results datastructure
! Out v_list_store     : pointer to list of storing index in results datastructure
!
! Warning : if v_list_store is required, don't forget to allocate object before use it
! First call: get nb_store
! Second call: get list_store
! 
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result
    integer :: i_dummy, tord(1)
    character(len=8) :: k8_dummy
    real(kind=8) :: r8_dummy
    complex(kind=8) :: c16_dummy
!
! --------------------------------------------------------------------------------------------------
!
    nb_store = 0
    result   = result_
    call rsorac(result   , 'LONUTI', 0       , r8_dummy, k8_dummy,&
                c16_dummy, r8_dummy, k8_dummy, tord    , 1       ,&
                i_dummy)
    nb_store = tord(1)
    if (nb_store .eq. 0) then
        call utmess('F', 'RESULT1_3', sk = result)
    endif
    if (present(v_list_store_)) then
        call rsorac(result   , 'TOUT_ORDRE', 0       , r8_dummy     , k8_dummy,&
                    c16_dummy, r8_dummy    , k8_dummy, v_list_store_, nb_store,&
                    i_dummy)
    endif
!
end subroutine
