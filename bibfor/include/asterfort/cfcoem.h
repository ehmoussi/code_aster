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
    subroutine cfcoem(ds_contact, l_frot      , node_slav_indx, i_cont_link,&
                      nb_dof_tot, nb_node_mast, nods_mast_indx, dof_indx   ,&
                      coef_cont , coef_fric_x , coef_fric_y)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: node_slav_indx
        integer, intent(in) :: i_cont_link
        integer, intent(in) :: nb_dof_tot
        integer, intent(in) :: nb_node_mast
        integer, intent(in) :: nods_mast_indx(9)
        integer, intent(in) :: dof_indx(30)
        real(kind=8), intent(in) :: coef_cont(30)
        real(kind=8), intent(in) :: coef_fric_x(30)
        real(kind=8), intent(in) :: coef_fric_y(30)
        aster_logical, intent(in) :: l_frot
    end subroutine cfcoem
end interface
