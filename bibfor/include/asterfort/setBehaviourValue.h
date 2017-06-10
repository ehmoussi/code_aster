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
    subroutine setBehaviourValue(rela_comp, defo_comp   , type_comp, type_cpla,&
                                 mult_comp, type_matg   , post_iter, kit_comp ,&
                                 nb_vari  , nb_vari_comp, nume_comp,&
                                 l_compor_, v_compor_)
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: defo_comp
        character(len=16), intent(in) :: type_comp
        character(len=16), intent(in) :: type_cpla
        character(len=16), intent(in) :: mult_comp
        character(len=16), intent(in) :: type_matg
        character(len=16), intent(in) :: post_iter
        character(len=16), intent(in) :: kit_comp(4)
        integer, intent(in)  :: nb_vari
        integer, intent(in)  :: nb_vari_comp(4)
        integer, intent(in)  :: nume_comp(4)
        character(len=16), intent(out), optional :: l_compor_(:)
        character(len=16), intent(out), optional, pointer :: v_compor_(:)
    end subroutine setBehaviourValue
end interface
