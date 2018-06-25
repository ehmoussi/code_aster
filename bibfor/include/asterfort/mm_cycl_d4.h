! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mm_cycl_d4(ds_contact, i_cont_poin, indi_cont_eval,indi_cont_prev,&
                    pres_cont_curr,pres_cont_prev)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(inout) :: ds_contact
        integer, intent(in) :: i_cont_poin
        integer, intent(in) :: indi_cont_eval
        integer, intent(in) :: indi_cont_prev
        real(kind=8), intent(in) :: pres_cont_curr
        real(kind=8), intent(in) :: pres_cont_prev
    end subroutine mm_cycl_d4
end interface
