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
    subroutine nmext3(mesh          , field    , field_type   , field_s      ,&
                      nb_cmp        , nb_elem  , nb_poin      , nb_spoi      ,&
                      type_extr_elem, type_extr, type_extr_cmp, type_sele_cmp,&
                      list_elem     , list_poin, list_spoi    , list_cmp     ,&
                      work_poin     , work_elem)
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: field
        character(len=24), intent(in) :: field_type
        character(len=24), intent(in) :: field_s
        integer, intent(in) :: nb_cmp
        integer, intent(in) :: nb_elem
        integer, intent(in) :: nb_poin
        integer, intent(in) :: nb_spoi
        character(len=8), intent(in) :: type_extr_elem
        character(len=8), intent(in) :: type_extr
        character(len=8), intent(in) :: type_extr_cmp
        character(len=8), intent(in) :: type_sele_cmp
        character(len=24), intent(in) :: list_elem
        character(len=24), intent(in) :: list_poin
        character(len=24), intent(in) :: list_spoi
        character(len=24), intent(in) :: list_cmp
        character(len=19), intent(in) :: work_poin
        character(len=19), intent(in) :: work_elem
    end subroutine nmext3
end interface
