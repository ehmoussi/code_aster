! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine cgtabl(table_container, nb_obje, obje_name, obje_sdname, nb_cham_theta)
        character(len=8), intent(in)  :: table_container
        integer, intent(in)           :: nb_obje, nb_cham_theta
        character(len=16), intent(in) :: obje_name(nb_obje)
        character(len=24), intent(in) :: obje_sdname(nb_obje)
    end subroutine cgtabl
end interface
