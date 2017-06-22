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
    subroutine liscad(phenom       , list_load      , i_load    , load_namez  , load_funcz,&
                      nb_info_typez, list_info_typez, info_typez, i_neum_laplz)
        character(len=4), intent(in) :: phenom
        character(len=19), intent(in) :: list_load
        integer, intent(in) :: i_load
        character(len=*), intent(in) :: load_namez
        character(len=*), intent(in) :: load_funcz
        integer, optional, intent(in) :: nb_info_typez
        character(len=*), optional, intent(in) :: list_info_typez(*)
        character(len=*), optional, intent(in) :: info_typez
        integer, optional, intent(in) :: i_neum_laplz
    end subroutine liscad
end interface
