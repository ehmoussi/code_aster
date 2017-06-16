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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdoch_nbload(l_load_user , list_load_resu, l_zero_allowed, nb_load,&
                         load_keyword)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/getvid.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: l_load_user
character(len=19), intent(in) :: list_load_resu
aster_logical, intent(in) :: l_zero_allowed
integer, intent(out) :: nb_load
character(len=16), intent(out) :: load_keyword
!
! --------------------------------------------------------------------------------------------------
!
! Mechanics/Thermics - Read parameters
!
! Get number of loads for loads datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  l_load_user    : .true. if loads come from user (EXCIT)
! In  list_load_resu : name of datastructure for list of loads from result datastructure
! In  l_zero_allowed : .true. if we can create "zero-load" list of loads datastructure
! Out nb_load        : number of loads for list of loads
! Out load_keyword   : factor keyword to read loads
!                      'None' => no load to read
!                      'EXCIT' or ' ' => depending on command
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_excit, iret_cable, iret_cable_cine, nocc, nb_excit
    character(len=8) :: load_name
    integer, pointer :: v_llresu_infc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_load      = 0
    load_keyword = 'None'
!
! - Detect keyword for loads
!
    if (getexm('EXCIT','CHARGE') .eq. 1) then
        load_keyword = 'EXCIT'
    endif
    if (getexm(' ', 'CHARGE') .eq. 1) then
        load_keyword = ' '
    endif
!
! - Count number of loads
!
    if (l_load_user) then
        if (load_keyword .eq. 'None') then
            nb_load = 0
        elseif (load_keyword .eq. '  ') then
            call getvid(load_keyword, 'CHARGE', iocc = 0, nbret=nocc)
            nb_load = abs(nocc)
        elseif (load_keyword .eq. 'EXCIT') then
            call getfac(load_keyword, nb_excit)
            do i_excit = 1, nb_excit
                call getvid(load_keyword, 'CHARGE', iocc = i_excit, scal=load_name, nbret=nocc)
!
! ------------- For DEFI_CABLE_BP: count load only if kinematic 
! ------------- (because Neumann is not load but initial stress)
!
                if (nocc .eq. 1) then
                    call jeexin(load_name//'.CHME.SIGIN.VALE', iret_cable)
                    if (iret_cable .eq. 0) then
                        nb_load = nb_load + 1
                    else
                        call jeexin(load_name//'.CHME.CIMPO.DESC', iret_cable_cine)
                        if (iret_cable_cine .ne. 0) then
                            nb_load = nb_load + 1
                        endif
                    endif
                endif
            end do
        else
            ASSERT(.false.)
        endif
    else
        call jeveuo(list_load_resu(1:19)//'.INFC', 'L', vi=v_llresu_infc)
        nb_load = v_llresu_infc(1)
    endif
!
! - No loads is allowed ?
!
    if (nb_load .eq. 0) then
        if (.not. l_zero_allowed) then
            call utmess('F', 'CHARGES_2')
        endif
    endif
!
end subroutine
