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

subroutine lisexp(list_load)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lisnch.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: list_load
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Exclude some loads with PILOTAGE
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load      : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_excl_load = 6
    character(len=6), parameter :: ligr_excl_char(nb_excl_load) = (/&
         '.ROTAT', '.FL1  ',&
         '.FELEC', '.EPSIN',&
         '.ONDPL', '.SIINT'/)
    character(len=24) :: lload_name, lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    integer :: i_load, i_excl_load, nb_load, iret, load_nume
    character(len=19) :: lchin
    character(len=8) :: load_name
!
! --------------------------------------------------------------------------------------------------
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    call jeveuo(lload_name, 'L', vk24 = v_load_name)
    call jeveuo(lload_info, 'L', vi   = v_load_info)
!
! - Number of loads
!
    call lisnch(list_load, nb_load)
!
! - Loop on loads
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(nb_load+i_load+1)
        if (load_nume .eq. 5) then
            do i_excl_load = 1, nb_excl_load
                lchin = load_name(1:8)//'.CHME.LIGRE'//ligr_excl_char(i_excl_load)
                call jeexin(lchin, iret)
                if (iret .ne. 0) then
                    call utmess('F', 'CHARGES_26', sk=load_name)
                endif
            enddo
        endif
    end do
!
end subroutine
