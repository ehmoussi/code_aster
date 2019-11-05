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
interface
    subroutine setBehaviourParaValue(v_crit       , parm_theta_thm, parm_alpha_thm,&
                                     hho_coef_stab, hho_type_stab , hho_type_calc ,&
                                     i_comp_      , l_carcri_     , v_carcri_)
        use Behaviour_type
        type(Behaviour_Crit), pointer :: v_crit(:)
        real(kind=8), intent(in) :: parm_theta_thm, parm_alpha_thm
        real(kind=8), intent(in) :: hho_coef_stab, hho_type_stab, hho_type_calc
        integer, optional, intent(in) :: i_comp_
        real(kind=8), intent(out), optional :: l_carcri_(:)
        real(kind=8), pointer, optional :: v_carcri_(:)
    end subroutine setBehaviourParaValue
end interface
