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

function isdiri(list_load, load_type_2)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/ischar.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical :: isdiri
    character(len=19), intent(in) :: list_load
    character(len=4), intent(in) :: load_type_2
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Return .true. if Dirichlet loads exist
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load      : name of datastructure for list of loads
! In  load_type_1    : second level of type
!                'DUAL' - AFFE_CHAR_MECA
!                'ELIM' - AFFE_CHAR_CINE
!                '    ' - All types
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lelim, ldual
!
! --------------------------------------------------------------------------------------------------
!
    lelim = ischar(list_load, 'DIRI', 'ELIM')
    ldual = ischar(list_load, 'DIRI', 'DUAL')
    if (load_type_2 .eq. '    ') then
        isdiri = lelim.or.ldual
    else if (load_type_2.eq.'ELIM') then
        isdiri = lelim
    else if (load_type_2.eq.'DUAL') then
        isdiri = ldual
    else
        ASSERT(.false.)
    endif

end function
