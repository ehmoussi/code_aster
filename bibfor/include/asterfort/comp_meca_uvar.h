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
    subroutine comp_meca_uvar(compor_info, vari_link_base, vari_redu, nb_vari_redu, codret)
        character(len=19), intent(in) :: compor_info
        character(len=8), intent(in) :: vari_link_base
        character(len=19), intent(in) :: vari_redu
        integer, intent(out) :: nb_vari_redu
        integer, intent(out) :: codret
    end subroutine comp_meca_uvar
end interface
