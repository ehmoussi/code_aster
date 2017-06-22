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
    subroutine vefpme(modelz, cara_elem, mate      , lload_namez , lload_infoz,&
                      inst  , varc_curr, vect_elemz, ligrel_calcz)
        character(len=*), intent(in) :: modelz
        character(len=*), intent(in) :: lload_namez
        character(len=*), intent(in) :: lload_infoz
        real(kind=8), intent(in) :: inst(3)
        character(len=*), intent(in) :: cara_elem
        character(len=*), intent(in) :: mate
        character(len=*), intent(in) :: varc_curr
        character(len=*), intent(in) :: ligrel_calcz
        character(len=*), intent(inout) :: vect_elemz
    end subroutine vefpme
end interface
