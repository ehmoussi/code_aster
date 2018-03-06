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
interface
    subroutine nmdiri(model  , ds_material, cara_elem, list_load,&
                      disp   , vediri     , nume_dof , cndiri   ,&
                      sddyna_, vite_      , acce_)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=19), intent(in) :: disp
        character(len=19), intent(in) :: vediri
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: cndiri
        character(len=19), optional, intent(in) :: sddyna_
        character(len=19), optional, intent(in) :: vite_, acce_
    end subroutine nmdiri
end interface
