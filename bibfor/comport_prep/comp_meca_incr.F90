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

subroutine comp_meca_incr(rela_comp, defo_comp, type_comp, l_etat_init)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lccree.h"
#include "asterc/lctest.h"
#include "asterc/lcdiscard.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: rela_comp
    character(len=16), intent(in) :: defo_comp
    character(len=16), intent(out) :: type_comp
    aster_logical, optional, intent(in) :: l_etat_init
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Select type of comportment (incremental or total)
!
! --------------------------------------------------------------------------------------------------
!
! In  l_etat_init : .true. if initial state is defined
! In  rela_comp   : comportement RELATION
! In  defo_comp   : type of deformation
! Out type_comp   : type of comportment (incremental or total)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=16) :: rela_code_py
!
! --------------------------------------------------------------------------------------------------
!
    call lccree(1, rela_comp, rela_code_py)
    call lctest(rela_code_py, 'PROPRIETES', 'COMP_ELAS', iret)
    call lcdiscard(rela_code_py)
    if (iret .eq. 0) then
        type_comp = 'COMP_INCR'
    else
        type_comp = 'COMP_ELAS'
        if (present(l_etat_init)) then
            if (l_etat_init) then
                type_comp = 'COMP_INCR'
            endif
        endif
        if (defo_comp .eq. 'PETIT_REAC') then
            type_comp = 'COMP_INCR'
        endif
    endif
!
end subroutine
