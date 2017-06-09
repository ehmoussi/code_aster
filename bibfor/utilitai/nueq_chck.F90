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

subroutine nueq_chck(prof_chnoz, nb_equaz, l_error, l_subs)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
!
    character(len=*), intent(in) :: prof_chnoz
    integer, optional, intent(out) :: nb_equaz
    logical, optional, intent(in) :: l_error
    logical, optional, intent(in) :: l_subs
!
! --------------------------------------------------------------------------------------------------
!
! Check prof_chno
!
! --------------------------------------------------------------------------------------------------
!
! In  prof_chno   : name of PROF_CHNO
! Out nb_equa     : number of equations
! In  l_error     : emits explicit message if present
! In  l_subs      : exclude non-unit numbering (excluding substructing) if present
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: prof_chno
    character(len=24) :: nueq, deeq
    integer :: len_v, nb_equa, i_equa
    integer, pointer :: p_nueq(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    prof_chno = prof_chnoz
    nueq = prof_chno//'.NUEQ'
    deeq = prof_chno//'.DEEQ'
    call jelira(deeq, 'LONMAX', len_v)
    call jelira(nueq, 'LONMAX', nb_equa)
    if (len_v.ne.2*nb_equa) then
        if (present(l_error)) then
            call utmess('F','CHAMPS_20')
        else
            ASSERT(.false.)       
        endif
    endif
    if (present(nb_equaz)) then
        nb_equaz = nb_equa
    endif
    if (present(l_subs)) then
        call jeveuo(nueq,'L',vi = p_nueq)
        do i_equa = 1, nb_equa
            ASSERT(p_nueq(i_equa).eq.i_equa)
        end do
    endif
end subroutine
