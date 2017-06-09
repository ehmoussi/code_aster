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
    subroutine mecgme(modelz   , cara_elemz    , matez    , list_load, inst_curr,&
                      disp_prev, disp_cumu_inst, inst_prev, compor   , matr_elem)
        character(len=*), intent(in) :: modelz
        character(len=*), intent(in) :: cara_elemz
        character(len=*), intent(in) :: matez
        character(len=19), intent(in) :: list_load
        real(kind=8), intent(in) :: inst_prev
        real(kind=8), intent(in) :: inst_curr
        character(len=19), intent(in) :: disp_prev
        character(len=19), intent(in) :: disp_cumu_inst
        character(len=24), intent(in) :: compor
        character(len=19), intent(in) :: matr_elem
    end subroutine mecgme
end interface
