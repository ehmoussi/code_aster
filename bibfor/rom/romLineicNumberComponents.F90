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
subroutine romLineicNumberComponents(nb_node, nb_equa, nb_cmp)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: nb_node, nb_equa
integer, intent(out) :: nb_cmp
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Count number of components by node for lineic model
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_node          : number of nodes
! In  nb_equa          : number of equations (length of empiric mode)
! Out nb_cmp           : number of components by node
!
! --------------------------------------------------------------------------------------------------
!
    if (mod(nb_equa, nb_node) .ne. 0) then
        call utmess('F', 'ROM5_53')
    endif
    nb_cmp = nb_equa/nb_node
!
end subroutine
