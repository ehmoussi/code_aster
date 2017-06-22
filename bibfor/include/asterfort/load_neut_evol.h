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
    subroutine load_neut_evol(nb_type_neumz, type_calc  , time_curr, load_name, load_type_ligr,&
                              load_opti_r  , load_para_r, load_obje, nb_obje)
        integer, intent(in) :: nb_type_neumz
        character(len=4), intent(in) :: type_calc
        real(kind=8), intent(in) :: time_curr
        character(len=8), intent(in) :: load_name
        character(len=6), intent(out) :: load_type_ligr
        character(len=16), intent(out) :: load_opti_r
        character(len=8), intent(out) :: load_para_r(2)
        character(len=19), intent(out) :: load_obje(2)
        integer, intent(out) :: nb_obje
    end subroutine load_neut_evol
end interface
