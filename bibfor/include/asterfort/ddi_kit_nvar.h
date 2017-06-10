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
    subroutine ddi_kit_nvar(rela_flua     , rela_plas   , rela_cpla   , rela_coup   ,&
                            type_model2   ,&
                            nb_vari_flua  , nb_vari_plas, nb_vari_cpla, nb_vari_coup,&
                            nume_comp_plas, nume_comp_flua)
        character(len=16), intent(in) :: rela_flua
        character(len=16), intent(in) :: rela_plas
        character(len=16), intent(in) :: rela_cpla
        character(len=16), intent(in) :: rela_coup
        character(len=16), intent(in) :: type_model2
        integer, intent(out) :: nb_vari_flua
        integer, intent(out) :: nb_vari_plas
        integer, intent(out) :: nb_vari_cpla
        integer, intent(out) :: nb_vari_coup
        integer, intent(out) :: nume_comp_plas
        integer, intent(out) :: nume_comp_flua
    end subroutine ddi_kit_nvar
end interface
