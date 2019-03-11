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

!
!
#include "asterf_types.h"
!
interface
    subroutine romAlgoMGS(nb_mode, nb_equa, syst_type, field_iden, base,&
                          vr_mode_in, vr_mode_out,&   
                          vc_mode_in, vc_mode_out)
        integer, intent(in) :: nb_mode, nb_equa
        character(len=1), intent(in) :: syst_type
        character(len=8), intent(in) :: base
        character(len=24), intent(in) :: field_iden
        real(kind=8), pointer, optional :: vr_mode_in(:), vr_mode_out(:) 
        complex(kind=8), pointer, optional :: vc_mode_in(:), vc_mode_out(:) 
    end subroutine romAlgoMGS
end interface
