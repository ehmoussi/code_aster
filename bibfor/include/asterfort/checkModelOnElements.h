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
    subroutine checkModelOnElements(modelz,&
                                    nb_elem     , list_elem     ,&
                                    nb_type_elem, list_type_elem,&
                                    nb_found)
        character(len=*), intent(in) :: modelz
        integer, intent(in) :: nb_elem
        integer, intent(in), pointer :: list_elem(:)
        integer, intent(in) :: nb_type_elem
        character(len=16), intent(in), pointer :: list_type_elem(:)
        integer, intent(out) :: nb_found
    end subroutine checkModelOnElements
end interface
