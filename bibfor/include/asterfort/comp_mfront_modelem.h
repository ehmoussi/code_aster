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
    subroutine comp_mfront_modelem(elem_type_name, l_mfront_cp ,&
                                   model_dim     , model_mfront,&
                                   codret        , type_cpla_)
        character(len=16), intent(in) :: elem_type_name
        aster_logical, intent(in) :: l_mfront_cp
        integer, intent(out) :: model_dim
        character(len=16), intent(out) :: model_mfront
        integer, intent(out) :: codret
        character(len=16), optional, intent(out) :: type_cpla_
    end subroutine comp_mfront_modelem
end interface
