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
    subroutine romModeSave(base        , i_mode     , model  ,&
                           field_name  , field_iden , field_refe , nb_equa,&
                           mode_vectr_ ,&
                           mode_vectc_ ,&
                           mode_freq_  ,&
                           nume_slice_ ,&
                           nb_snap_)
        character(len=8), intent(in) :: base
        integer, intent(in) :: i_mode
        character(len=8), intent(in) :: model
        character(len=24), intent(in) :: field_name
        character(len=24), intent(in) :: field_iden
        character(len=24), intent(in) :: field_refe
        integer, intent(in) :: nb_equa
        real(kind=8), optional, intent(in) :: mode_vectr_(nb_equa)
        complex(kind=8), optional, intent(in) :: mode_vectc_(nb_equa)
        integer, optional, intent(in)     :: nume_slice_
        real(kind=8), optional, intent(in) :: mode_freq_
        integer, optional, intent(in)     :: nb_snap_
    end subroutine romModeSave
end interface
