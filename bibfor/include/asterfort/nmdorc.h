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
    subroutine nmdorc(model, chmate, l_etat_init, compor, carcri, mult_comp_, l_implex_)
        character(len=*), intent(in) :: model
        character(len=*), intent(in) :: chmate
        aster_logical, intent(in) :: l_etat_init
        character(len=*), intent(in) :: compor
        character(len=*), intent(out) :: carcri
        character(len=*), optional, intent(in) :: mult_comp_
        aster_logical, optional, intent(in) :: l_implex_
    end subroutine nmdorc
end interface
