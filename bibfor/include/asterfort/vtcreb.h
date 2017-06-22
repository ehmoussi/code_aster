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
    subroutine vtcreb(field_nodez , base      , type_scalz,&
                      nume_ddlz   ,&
                      meshz       , prof_chnoz, idx_gdz, nb_equa_inz,&
                      nb_equa_outz)
        character(len=*), intent(in) :: field_nodez
        character(len=1), intent(in) :: base
        character(len=*), intent(in) :: type_scalz
        character(len=*), optional, intent(in) :: nume_ddlz
        character(len=*), optional, intent(in) :: meshz
        character(len=*), optional, intent(in) :: prof_chnoz
        integer, optional, intent(in) :: nb_equa_inz
        integer, optional, intent(in) :: idx_gdz
        integer, optional, intent(out) :: nb_equa_outz
    end subroutine vtcreb
end interface
