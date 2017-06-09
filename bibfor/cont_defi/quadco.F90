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

subroutine quadco(sdcont, l_node_q8)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    aster_logical, intent(out) :: l_node_q8
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Discrete method - QUAD8 specific treatment activation
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! Out l_node_q8        : .true. if nead linearization for QUAD8
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_defi
    aster_logical :: l_all_verif, l_pena_cont, l_gliss
!
! --------------------------------------------------------------------------------------------------
!
    l_node_q8   = .true.
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Parameters
!
    l_all_verif = cfdisl(sdcont_defi,'ALL_VERIF')
    l_pena_cont = cfdisl(sdcont_defi,'CONT_PENA')
    l_gliss     = cfdisl(sdcont_defi,'CONT_DISC_GLIS')
!
! - Activate elimination of QUAD8 middle nodes
!
    if (l_all_verif .or. l_pena_cont .or. l_gliss) then
        l_node_q8 = .false.
    else
        l_node_q8 = .true.
    endif
!
end subroutine
