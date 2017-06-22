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
interface
    subroutine cfcoef(ds_contact    , model_ndim , nb_node_mast, nods_mast_indx, coef_node,&
                      node_slav_indx, norm       , tau1        , tau2          , coef_cont,&
                      coef_fric_x   , coef_fric_y, nb_dof_tot  , dof_indx)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: model_ndim
        integer, intent(in) :: nb_node_mast
        integer, intent(in) :: nods_mast_indx(9)
        integer, intent(in) :: node_slav_indx
        real(kind=8), intent(in) :: coef_node(9)
        real(kind=8), intent(in) :: norm(3)
        real(kind=8), intent(in) :: tau1(3)
        real(kind=8), intent(in) :: tau2(3)
        real(kind=8), intent(out) :: coef_cont(30)
        real(kind=8), intent(out) :: coef_fric_x(30)
        real(kind=8), intent(out) :: coef_fric_y(30)
        integer, intent(out) :: dof_indx(30)
        integer, intent(out) :: nb_dof_tot
    end subroutine cfcoef
end interface
