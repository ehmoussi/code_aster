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
    subroutine char_rcbp_cabl(cabl_prec, list_cabl, list_anc1, list_anc2, nb_cabl, &
                              nb_anc1, nb_anc2)
        character(len=8), intent(in) :: cabl_prec
        character(len=24), intent(in) :: list_cabl
        character(len=24), intent(in) :: list_anc1
        character(len=24), intent(in) :: list_anc2
        integer, intent(out) :: nb_cabl
        integer, intent(out) :: nb_anc1
        integer, intent(out) :: nb_anc2
    end subroutine char_rcbp_cabl
end interface
