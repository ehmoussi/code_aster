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
    subroutine ntetcr(nume_dof  , ds_inout,&
                      list_load_, compor_ , hydr_, hydr_init_)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: nume_dof
        type(NL_DS_InOut), intent(inout) :: ds_inout
        character(len=19), optional, intent(in) :: list_load_
        character(len=*), optional, intent(in) :: compor_
        character(len=*), optional, intent(in) :: hydr_
        character(len=*), optional, intent(in) :: hydr_init_
    end subroutine ntetcr
end interface
