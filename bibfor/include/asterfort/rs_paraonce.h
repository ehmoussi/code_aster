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
!
interface 
    subroutine rs_paraonce(result   , nb_para      , list_para,&
                           nb_store_, v_list_store_)
        character(len=8), intent(in) :: result
        integer, intent(in) :: nb_para
        character(len=*), intent(in) :: list_para(*)
        integer, optional, intent(in) :: nb_store_
        integer, pointer, optional :: v_list_store_(:)
    end subroutine rs_paraonce
end interface 
