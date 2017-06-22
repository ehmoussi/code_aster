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

!
!
#include "asterf_types.h"
!
interface
    subroutine lislfc(list_load_resu, i_load, indic , l_load_user, nexci,&
                      lfcplx        , lacce , fctcsr, nomfct)
        aster_logical :: lfcplx, lacce, l_load_user
        integer :: i_load, indic
        integer :: nexci
        character(len=19) :: list_load_resu
        character(len=8) :: fctcsr
        character(len=8) :: nomfct
    end subroutine lislfc
end interface
