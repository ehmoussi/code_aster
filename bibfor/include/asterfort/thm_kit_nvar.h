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
    subroutine thm_kit_nvar(rela_thmc     , rela_hydr     , rela_meca     , rela_ther     ,&
                            nb_vari_thmc  , nb_vari_hydr  , nb_vari_meca  , nb_vari_ther  ,&
                            nume_comp_thmc, nume_comp_hydr, nume_comp_meca, nume_comp_ther)
        character(len=16), intent(in) :: rela_thmc
        character(len=16), intent(in) :: rela_hydr
        character(len=16), intent(in) :: rela_meca
        character(len=16), intent(in) :: rela_ther
        integer, intent(out) :: nb_vari_thmc
        integer, intent(out) :: nb_vari_hydr
        integer, intent(out) :: nb_vari_meca
        integer, intent(out) :: nb_vari_ther
        integer, intent(out) :: nume_comp_thmc
        integer, intent(out) :: nume_comp_hydr
        integer, intent(out) :: nume_comp_meca
        integer, intent(out) :: nume_comp_ther
    end subroutine thm_kit_nvar
end interface
