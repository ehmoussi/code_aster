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
    subroutine cmpcha(fieldz    , cmp_name, cata_to_field, field_to_cata, nb_cmpz,&
                      nb_cmp_mxz)
        character(len=*), intent(in) :: fieldz
        character(len=8), pointer, intent(out) :: cmp_name(:)
        integer, pointer, intent(out) :: cata_to_field(:)
        integer, pointer, intent(out) :: field_to_cata(:)
        integer, optional, intent(out) :: nb_cmpz
        integer, optional, intent(out) :: nb_cmp_mxz
    end subroutine cmpcha
end interface
