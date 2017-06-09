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
    subroutine nmexti(node_name, field    , nb_cmp, list_cmp, type_extr_cmp,&
                      nb_vale  , vale_resu)
        character(len=8), intent(in) :: node_name
        character(len=19), intent(in) :: field
        integer, intent(in) :: nb_cmp
        character(len=24), intent(in) :: list_cmp
        character(len=8), intent(in) :: type_extr_cmp
        real(kind=8), intent(out) :: vale_resu(*)
        integer, intent(out) :: nb_vale
    end subroutine nmexti
end interface
