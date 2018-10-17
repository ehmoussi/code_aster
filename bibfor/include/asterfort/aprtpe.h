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
interface
    subroutine aprtpe(elem_dime   , elem_code, indx_tria_elem,&
                      nb_poin_inte, poin_inte)
        integer, intent(in) :: elem_dime
        character(len=8), intent(in) :: elem_code
        integer, intent(in) :: indx_tria_elem
        integer, intent(in) :: nb_poin_inte
        real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
    end subroutine aprtpe
end interface
