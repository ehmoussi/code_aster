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
! person_in_charge: mickael.abbas at edf.fr
!
function ischar(list_load, load_type_1, load_type_2, i_load_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ischar_iden.h"
!
aster_logical :: ischar
character(len=19), intent(in) :: list_load
character(len=4), intent(in) :: load_type_1
character(len=4), intent(in) :: load_type_2
integer, optional, intent(in) :: i_load_
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Return type of load
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load      : name of datastructure for list of loads
! In  load_type_1    : first level of type
!                'DIRI' - DIRICHLET
!                'NEUM' - NEUMANN
! In  load_type_2    : second level of type
! -> For Dirichlet loads
!                'DUAL' - AFFE_CHAR_MECA
!                'ELIM' - AFFE_CHAR_CINE
!                'DIDI' - Differential
!                'SUIV' - Undead load
!                '    ' - All types
! -> For Neumann loads
!                'ONDE' - ONDE PLANE
!                'SIGM' - SIGMA_INTERNE
!                'LAPL' - FORCE DE LAPLACE
!                'TARD' - ELEMENTS TARDIFS
!                'SUIV' - Undead load
!                '    ' - All types
! In  i_load         : index in list of loads
!                      if not present, loop on all loads in list
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, i_load, nb_load
    aster_logical :: ischar_iload
    character(len=24) :: lload_name, lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    ischar = .false.
!
! - Datastructure access
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    call jeveuo(lload_name, 'L', vk24 = v_load_name)
    call jeveuo(lload_info, 'L', vi   = v_load_info)
!
! - Exist ?
!
    call jeexin(lload_name, iret)
    if (iret .eq. 0) then
        ischar = .false.
        goto 99
    endif
    nb_load = v_load_info(1)
    if (nb_load .eq. 0) then
        ischar = .false.
        goto 99
    endif
!
! - Choice: all loads or not ?
!
    if (present(i_load_)) then
        ischar_iload = ischar_iden(v_load_info, i_load_, nb_load, load_type_1, load_type_2)
        ischar = ischar_iload
    else
        do i_load = 1, nb_load
!
! --------- Identify type of load 
!
            ischar_iload = ischar_iden(v_load_info, i_load, nb_load, load_type_1, load_type_2)
!
! --------- Flag for function
!    
            if (ischar_iload) then
                ischar = ischar_iload
                goto 99
            endif
        end do
    endif
!
 99 continue
!
    call jedema()
end function
