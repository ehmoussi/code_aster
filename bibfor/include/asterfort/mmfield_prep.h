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
    subroutine mmfield_prep(field_in    , field_out    ,&
                            l_update_   , field_update_, alpha_   ,&
                            l_sort_     , nb_cmp_      , list_cmp_)
        character(len=*), intent(in) :: field_in
        character(len=*), intent(in) :: field_out
        aster_logical, optional, intent(in) :: l_update_
        aster_logical, optional, intent(in) :: l_sort_
        integer, optional, intent(in) :: nb_cmp_
        character(len=8), optional, intent(in):: list_cmp_(*)
        character(len=*), optional, intent(in) :: field_update_
        real(kind=8), optional, intent(in) :: alpha_
    end subroutine mmfield_prep
end interface
