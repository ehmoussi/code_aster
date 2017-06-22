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

subroutine lobs(sd_obsv, nume_time, time, l_obsv)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/impfoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcrpo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sd_obsv
    integer, intent(in) :: nume_time
    real(kind=8), intent(in) :: time
    aster_logical, intent(out) :: l_obsv
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - Observation
!
! Decision for observation
!
! --------------------------------------------------------------------------------------------------
!
! In  sd_obsv          : datastructure for observation parameters
! In  time             : current time
! In  nume_time        : index of time
! Out l_obsv           : .true. if execute observation
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: sdextr_obsv
    integer :: i_keyw_fact, nb_keyw_fact
    character(len=2) :: chaine
    character(len=19) :: list_inst_obsv
    aster_logical :: l_select, l_obse_init
    character(len=24) :: extr_info, extr_flag
    integer, pointer :: v_extr_info(:) => null()
    aster_logical, pointer :: v_extr_flag(:) => null()
    character(len=24) :: obsv_init
    character(len=8), pointer :: v_obsv_init(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    l_obsv = .false.
!
! - Access to extraction datastructure
!
    sdextr_obsv = sd_obsv(1:14)
!
! - Get information vector
!
    extr_info    = sdextr_obsv(1:14)//'     .INFO'
    call jeveuo(extr_info, 'L', vi = v_extr_info)
    nb_keyw_fact = v_extr_info(1)
!
    if (nb_keyw_fact .ne. 0) then
!
! ----- Initial observation
!
        obsv_init = sd_obsv(1:14)//'     .INIT'
        call jeveuo(obsv_init, 'L', vk8 = v_obsv_init)
!
! ----- Access to extraction flag vector
!
        extr_flag = sdextr_obsv(1:14)//'     .ACTI'
        call jeveuo(extr_flag, 'E', vl = v_extr_flag)
!
! ----- Initial time: always !
!
        if (nume_time .eq. 0) then
            do i_keyw_fact = 1, nb_keyw_fact
                l_obse_init = v_obsv_init(i_keyw_fact).eq.'OUI'
                if (l_obse_init) then
                    v_extr_flag(i_keyw_fact) = .true.
                else
                    v_extr_flag(i_keyw_fact) = .false.
                endif
                l_obsv = l_select.or.l_obse_init
            end do
            goto 99
        endif
!
! ----- Other times ?
!
        do i_keyw_fact = 1, nb_keyw_fact
            call impfoi(0, 2, i_keyw_fact, chaine)
            list_inst_obsv = sd_obsv(1:14)//chaine(1:2)//'.LI'
            call nmcrpo(list_inst_obsv, nume_time, time, l_select)
            v_extr_flag(i_keyw_fact) = l_select
            l_obsv = l_select.or.l_obsv
        end do
 99     continue
    endif
!
end subroutine
