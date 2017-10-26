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
interface
    subroutine comp_nbvari_kit(kit_comp  , defo_comp   , nb_vari_rela,&
                               l_kit_meta, l_kit_thm   , l_kit_ddi   , l_kit_cg     ,&
                               nb_vari   , nb_vari_comp, nume_comp   , l_meca_mfront)
        character(len=16), intent(in) :: kit_comp(4)
        character(len=16), intent(in) :: defo_comp
        integer, intent(in) :: nb_vari_rela
        aster_logical, intent(in) :: l_kit_meta
        aster_logical, intent(in) :: l_kit_thm
        aster_logical, intent(in) :: l_kit_ddi
        aster_logical, intent(in) :: l_kit_cg
        integer, intent(inout) :: nb_vari
        integer, intent(inout) :: nume_comp(4)
        integer, intent(out) :: nb_vari_comp(4)
        aster_logical, intent(out) :: l_meca_mfront
    end subroutine comp_nbvari_kit
end interface
