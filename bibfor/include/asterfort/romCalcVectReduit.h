! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine romCalcVectReduit(i_mode     , nb_equa    , nb_vect,&
                                 l_vect_name, l_vect_type, l_vect_redu,&
                                 mode_type  , vc_mode    , vr_mode)
        integer, intent(in) :: i_mode, nb_vect, nb_equa
        character(len=8), intent(in) :: l_vect_name(:)
        character(len=1), intent(in) :: l_vect_type(:)
        character(len=24), intent(in) :: l_vect_redu(:)
        character(len=1), intent(in) :: mode_type
        complex(kind=8), pointer, optional :: vc_mode(:)
        real(kind=8), pointer, optional :: vr_mode(:)
    end subroutine romCalcVectReduit
end interface
