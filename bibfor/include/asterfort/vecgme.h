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
    subroutine vecgme(model    , cara_elem   , matez          , lload_namez, lload_infoz,&
                      inst_curr, disp_prevz  , disp_cumu_instz, vect_elemz , inst_prev  ,&
                      compor   , ligrel_calcz, vite_currz     , strx_prevz )
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: cara_elem
        character(len=*), intent(in) :: matez
        real(kind=8), intent(in) :: inst_curr
        character(len=*), intent(in) :: disp_prevz
        character(len=*), intent(in) :: disp_cumu_instz
        character(len=*), intent(in) :: lload_namez
        character(len=*), intent(in) :: lload_infoz
        character(len=*), intent(inout) :: vect_elemz
        real(kind=8), intent(in) :: inst_prev
        character(len=24), intent(in) :: compor
        character(len=*), intent(in) :: ligrel_calcz
        character(len=*), intent(in) :: vite_currz
        character(len=*), intent(in) :: strx_prevz
    end subroutine vecgme
end interface
