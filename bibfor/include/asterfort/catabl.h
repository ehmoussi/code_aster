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
    subroutine catabl(table_new, table_old  , time, nume_store, nb_obje,&
                      obje_name, obje_sdname)
        character(len=8), intent(in) :: table_new
        character(len=8), intent(in) :: table_old
        real(kind=8), intent(in) :: time
        integer, intent(in) :: nume_store
        integer, intent(in) :: nb_obje
        character(len=16), intent(in) :: obje_name(nb_obje)
        character(len=24), intent(in) :: obje_sdname(nb_obje)
    end subroutine catabl
end interface
