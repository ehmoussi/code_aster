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
    subroutine mmbclc(mesh  , model , iter_newt, nume_inst, ds_measure,&
                      sddisc, sddyna, hval_incr, hval_algo, ds_contact)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        integer, intent(in) :: iter_newt
        integer, intent(in) :: nume_inst
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: sddyna
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
    end subroutine mmbclc
end interface
