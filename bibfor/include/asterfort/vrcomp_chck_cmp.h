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
    subroutine vrcomp_chck_cmp(mesh, nb_elem,&
                               compor_curr, compor_curr_r, compor_prev_r, &
                               vari_r, comp_comb_2,&
                               ligrel_curr, ligrel_prev,&
                               no_same_spg, no_same_cmp, l_modif_vari)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nb_elem
        character(len=*), intent(in)  :: compor_curr
        character(len=19), intent(in) :: compor_curr_r
        character(len=19), intent(in) :: compor_prev_r
        character(len=19), intent(in) :: vari_r
        character(len=48), intent(in) :: comp_comb_2
        character(len=19), intent(in) :: ligrel_curr
        character(len=19), intent(in) :: ligrel_prev
        aster_logical, intent(out) :: no_same_spg
        aster_logical, intent(out) :: no_same_cmp
        aster_logical, intent(out) :: l_modif_vari
    end subroutine vrcomp_chck_cmp
end interface
