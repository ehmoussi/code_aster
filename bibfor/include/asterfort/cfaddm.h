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
    subroutine cfaddm(ds_contact, l_frot      , node_slav_indx, i_cont_link,&
                      model_ndim, nb_node_mast, nods_mast_indx, coef_node  , tau1,&
                      tau2, norm, jeu, coornp)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer :: node_slav_indx, i_cont_link
        integer :: nb_node_mast, model_ndim
        integer :: nods_mast_indx(*)
        real(kind=8) :: coef_node(*)
        real(kind=8) :: jeu, coornp(3)
        real(kind=8) :: norm(3), tau1(3), tau2(3)
        aster_logical :: l_frot
    end subroutine cfaddm
end interface
