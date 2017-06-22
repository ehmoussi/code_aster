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
    subroutine mm_cycl_trait(ds_contact    , i_cont_poin, &
                             coef_cont_prev, &
                             coef_frot_prev, pres_frot_prev, dist_frot_prev, &
                             pres_frot_curr, dist_frot_curr, &
                             indi_cont_eval, indi_frot_eval, &
                             indi_cont_curr, coef_cont_curr, &
                             indi_frot_curr, coef_frot_curr)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: i_cont_poin
        real(kind=8), intent(in) :: coef_cont_prev
        real(kind=8), intent(in) :: coef_frot_prev
        real(kind=8), intent(in) :: pres_frot_prev(3)
        real(kind=8), intent(in) :: dist_frot_prev(3)
        real(kind=8), intent(in) :: pres_frot_curr(3)
        real(kind=8), intent(in) :: dist_frot_curr(3)
        integer, intent(in) :: indi_cont_eval
        integer, intent(in) :: indi_frot_eval
        integer, intent(out) :: indi_cont_curr
        integer, intent(out) :: indi_frot_curr
        real(kind=8), intent(out) :: coef_cont_curr
        real(kind=8), intent(out) :: coef_frot_curr
    end subroutine mm_cycl_trait
end interface
