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

subroutine conv_int(sens, nb, vi_ast, vi_med)
!
!     utilitaire de conversion de tableaux d'entiers :
!     aster_int <---> ast_med
!
!     sens= / 'ast->med'
!           / 'med->ast'
!     nb : nombre de valeurs dans les tableaux vi_ast et vi_med
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    character(len=*) :: sens
    aster_int :: nb
    aster_int :: vi_ast(nb)
    med_int :: vi_med(nb)
    integer :: i

    if (sens.eq.'ast->med') then
        do  i = 1, nb
            vi_med(i) = to_med_int(vi_ast(i))
        enddo

    elseif (sens.eq.'med->ast') then
        do  i = 1, nb
            vi_ast(i) = to_aster_int(vi_med(i))
        enddo

    else
        ASSERT(.false.)
    endif
end subroutine
