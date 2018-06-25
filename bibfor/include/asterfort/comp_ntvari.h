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
#include "asterf_types.h"
!
interface
    subroutine comp_ntvari(model_ , compor_cart_, compor_list_, compor_info,&
                           nt_vari, nb_vari_maxi, nb_zone     , v_exte)
        use Behaviour_type
        character(len=8), optional, intent(in) :: model_
        character(len=19), optional, intent(in) :: compor_cart_
        character(len=16), optional, intent(in) :: compor_list_(20)
        character(len=19), intent(in) :: compor_info
        integer, intent(out) :: nt_vari
        integer, intent(out) :: nb_vari_maxi
        integer, intent(out) :: nb_zone
        type(Behaviour_External), pointer :: v_exte(:)
    end subroutine comp_ntvari
end interface
